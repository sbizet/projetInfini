#include "Arduino.h"
#include <Wire.h>
class AccelGyro
{
  typedef union accel_t_gyro_union
  {
    struct
    {
      uint8_t x_accel_h;
      uint8_t x_accel_l;
      uint8_t y_accel_h;
      uint8_t y_accel_l;
      uint8_t z_accel_h;
      uint8_t z_accel_l;
      uint8_t t_h;
      uint8_t t_l;
      uint8_t x_gyro_h;
      uint8_t x_gyro_l;
      uint8_t y_gyro_h;
      uint8_t y_gyro_l;
      uint8_t z_gyro_h;
      uint8_t z_gyro_l;
    } reg;
    struct 
    {
      int x_accel;
      int y_accel;
      int z_accel;
      int temperature;
      int x_gyro;
      int y_gyro;
      int z_gyro;
    } value;
  };

  unsigned long last_read_time;
  float         last_y_angle;
  float gyro_y;
  
  float    base_x_accel;
  float    base_y_accel;
  float    base_z_accel;
  float    base_x_gyro;
  float    base_y_gyro;
  float    base_z_gyro;
  
  public:
    int nMesuresAngle = 0;
    int nMesuresGyro = 0;
    float sum_y_angle = 0;
    float sum_gyro_y = 0;
    
    void init(){
        int error;
        uint8_t c;
        
        Wire.begin();
        
        error = MPU6050_read (0x75, &c, 1);
        error = MPU6050_read (0x6C, &c, 1);
        MPU6050_write_reg (0x6B, 0);
        
        calibrate_sensors();  
        
        last_read_time = millis();
        last_y_angle = 0;
    }
    void update(){
      int error;
      double dT;
      accel_t_gyro_union accel_t_gyro;
      error = read_gyro_accel_vals((uint8_t*) &accel_t_gyro);
      unsigned long t_now = millis();
  
      // Convert gyro values to degrees/sec
      float FS_SEL = 131;
  
      gyro_y = (accel_t_gyro.value.y_gyro - base_y_gyro)/FS_SEL;
      
      float accel_x = accel_t_gyro.value.x_accel;
      float accel_y = accel_t_gyro.value.y_accel;
      float accel_z = accel_t_gyro.value.z_accel;
      
      float RADIANS_TO_DEGREES = 180/3.14159;
      float accel_angle_y = atan(accel_x/accel_z)*RADIANS_TO_DEGREES;
      if (accel_x > 0 && accel_z < 0) accel_angle_y = 180 +accel_angle_y;
      if (accel_x < 0 && accel_z < 0) accel_angle_y = -180+accel_angle_y;
  
      float dt =(t_now - last_read_time)/1000.0;
      float gyro_angle_y = gyro_y*dt + last_y_angle;
      
      float alpha = 0.96;
      float angle_y = alpha*gyro_angle_y + (1.0 - alpha)*accel_angle_y;
      
      last_y_angle = angle_y;
      last_read_time = t_now;
      
      
    }

    float getAngle(){ // renvoi la valeur moyenne des angles 
      sum_y_angle += last_y_angle;
      nMesuresAngle++;
      return sum_y_angle/nMesuresAngle;
    }

    float getVRot(){ // renvoi la valeur moyenne des vitesses de rotations
      sum_gyro_y += gyro_y;
      nMesuresGyro++;
      return sum_gyro_y/nMesuresGyro;
    }

    void razMoyenne(){ // remets à 0 les valeurs moyennes des angles et vitesses de rotation
      sum_y_angle = 0;
      nMesuresAngle = 0;
      sum_gyro_y = 0;
      nMesuresGyro = 0;
    }
    
    int MPU6050_read(int start, uint8_t *buffer, int size){
      int i, n, error;

      Wire.beginTransmission(0x68);
      n = Wire.write(start);
      if (n != 1)
      return (-10);

      n = Wire.endTransmission(false);    // hold the I2C-bus
      if (n != 0)
      return (n);
  
      // Third parameter is true: relase I2C-bus after data is read.
      Wire.requestFrom(0x68, size, true);
      i = 0;
      while(Wire.available() && i<size)
      {
      buffer[i++]=Wire.read();
      }
      if ( i != size)
      return (-11);
  
      return (0);  // return : no error
    }


  int MPU6050_write(int start, const uint8_t *pData, int size){
    int n, error;

    Wire.beginTransmission(0x68);
    n = Wire.write(start);        // write the start address
    if (n != 1)
    return (-20);

    n = Wire.write(pData, size);  // write data bytes
    if (n != size)
    return (-21);

    error = Wire.endTransmission(true); // release the I2C-bus
    if (error != 0)
    return (error);
    return (0);         // return : no error
  }


  int MPU6050_write_reg(int reg, uint8_t data){
    int error;
    error = MPU6050_write(reg, &data, 1);
    return (error);
  }

  int read_gyro_accel_vals(uint8_t* accel_t_gyro_ptr) {
    accel_t_gyro_union* accel_t_gyro = (accel_t_gyro_union *) accel_t_gyro_ptr;
     
    int error = MPU6050_read (0x3B, (uint8_t *) accel_t_gyro, sizeof(*accel_t_gyro));

    uint8_t swap;
    #define SWAP(x,y) swap = x; x = y; y = swap

    SWAP ((*accel_t_gyro).reg.x_accel_h, (*accel_t_gyro).reg.x_accel_l);
    SWAP ((*accel_t_gyro).reg.y_accel_h, (*accel_t_gyro).reg.y_accel_l);
    SWAP ((*accel_t_gyro).reg.z_accel_h, (*accel_t_gyro).reg.z_accel_l);
    SWAP ((*accel_t_gyro).reg.t_h, (*accel_t_gyro).reg.t_l);
    SWAP ((*accel_t_gyro).reg.x_gyro_h, (*accel_t_gyro).reg.x_gyro_l);
    SWAP ((*accel_t_gyro).reg.y_gyro_h, (*accel_t_gyro).reg.y_gyro_l);
    SWAP ((*accel_t_gyro).reg.z_gyro_h, (*accel_t_gyro).reg.z_gyro_l);

    return error;
  }

// The sensor should be motionless on a horizontal surface 
//  while calibration is happening
  void calibrate_sensors() {
    int                   num_readings = 10;
    float                 x_accel = 0;
    float                 y_accel = 0;
    float                 z_accel = 0;
    float                 x_gyro = 0;
    float                 y_gyro = 0;
    float                 z_gyro = 0;
    accel_t_gyro_union    accel_t_gyro;
    
    read_gyro_accel_vals((uint8_t *) &accel_t_gyro);
    
    for (int i = 0; i < num_readings; i++) {
    read_gyro_accel_vals((uint8_t *) &accel_t_gyro);
    x_accel += accel_t_gyro.value.x_accel;
    y_accel += accel_t_gyro.value.y_accel;
    z_accel += accel_t_gyro.value.z_accel;
    x_gyro += accel_t_gyro.value.x_gyro;
    y_gyro += accel_t_gyro.value.y_gyro;
    z_gyro += accel_t_gyro.value.z_gyro;
    delay(100);
    }
    x_accel /= num_readings;
    y_accel /= num_readings;
    z_accel /= num_readings;
    x_gyro /= num_readings;
    y_gyro /= num_readings;
    z_gyro /= num_readings;
    
    base_x_accel = x_accel;
    base_y_accel = y_accel;
    base_z_accel = z_accel;
    base_x_gyro = x_gyro;
    base_y_gyro = y_gyro;
    base_z_gyro = z_gyro;
  }

};
