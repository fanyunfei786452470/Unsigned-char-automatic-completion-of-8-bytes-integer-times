//
//  main.m
//  NIST_Tool
//
//  Created by 范云飞 on 2017/11/9.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zalglib.h"
#include <stdio.h>
#include <string.h>
void unsignedchar2(unsigned char * input,unsigned char * output,int len );
void unsignedchar1(unsigned char * input,unsigned char * output,int len );
void unsignedchar(unsigned char * input, unsigned long long * output, int len);
void unsignedcharFromUnsignedlonglong(unsigned long long * input, unsigned char * output, int len);

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        
#pragma mark - 8的整数倍
        unsigned char input[] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77};
        int total = sizeof(input);
        unsigned long long output[total/8];
        
        //8的整数倍
        if (total/8 >= 1 && (total%8) == 0)
        {
            unsignedchar(input, output, total);
        }

#pragma mark - 小于8的数
//        unsigned char input[] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66};
//        int total = sizeof(input);
//        unsigned char output[8];

//        //小于8的数
//        if (total/8 == 0)
//        {
//            unsignedchar1(input, output, total);
//        }
//        
        
#pragma mark 大于8的数
//        unsigned char input[] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x33,0x44};
//        int total = sizeof(input);
//        unsigned char output[16];
//        
//        //大于8的数
//        if (total/8 >= 1 && (total%8) != 0)
//        {
//            unsignedchar2(input, output, total);
//        }

    }
    return 0;
}

void unsignedchar2(unsigned char * input,unsigned char * output,int len )
{
    //在此需要补充 8 - total%8 个字节
    for (int i = 0; i < len; i++)
    {
        printf("%hhx\n",input[i]);
    }
    
    unsigned char chong[1] = {0x00};
    unsigned char buchong[8 - len%8];
    for (int i = 0; i < 8 - len%8; i++)
    {
        memcpy(buchong + i, chong, 1);
    }
    memcpy(output, input, len);
    memcpy(output + len, buchong, 8- len%8);
    
    for (int i = 0; i < 16; i++)
    {
        printf("%hhx\n",output[i]);
    }
}
void unsignedchar1(unsigned char * input,unsigned char * output,int len )
{
    //在此需要补充 8 - total 个字节的0x00
    for (int i = 0; i < len; i++)
    {
        printf("%hhx\n",input[i]);
    }
    
    unsigned char chong[1] = {0x00};
    unsigned char buchong[8 - len];
    for (int i = 0; i < 8 - len; i++)
    {
        memcpy(buchong + i, chong, 1);
    }
    memcpy(output, input, len);
    memcpy(input + len, buchong, 8 - len);
    
    for (int i = 0; i < len; i++)
    {
        printf("%hhx\n",output[i]);
    }

}

void unsignedchar(unsigned char * input, unsigned long long * output, int len)
{
    //8的整数倍
    for (int i = 0; i < len; i++)
    {
        printf("%hhx\n",input[i]);
    }
    
    memcpy(output, input, len);
    
    for (int i = 0; i < len/8; i++)
    {
        printf("%llx\n",output[i]);
    }
}

#pragma mark - unsigned long long -> unsigned char
void unsignedcharFromUnsignedlonglong(unsigned long long * input, unsigned char * output, int len)
{
    memcpy(output, input, len);
}
