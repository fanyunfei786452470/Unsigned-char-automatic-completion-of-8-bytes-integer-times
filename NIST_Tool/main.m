//
//  main.m
//  NIST_Tool
//
//  Created by 范云飞 on 2017/11/9.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
void  NIST_xor_encrypt(unsigned char * data, unsigned char * key, int dlen, int klen);

void convertUnsignedCharToUnsignedChar(unsigned char * key, int klen, unsigned char * intput, int ilen, unsigned char * output);/* unsigned char -> unsigned char */

void convertUnsignedCharToUnsignedlonglong(unsigned char * input, unsigned long long * output, int len);/* unsigned char -> unsigned long long */
void convertUnsignedlonglongToUnsignedChar(unsigned long long * input, unsigned char * output, int len);/* unsigned long long -> unsigned char */

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
#pragma mark - unsigned char ->unsigned long long
        
#pragma mark - 8的整数倍
        //        unsigned char input[] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x77};
        //        int total = sizeof(input);
        //        unsigned long long output[10];
        //
        //        //8的整数倍
        //        convertUnsignedCharToUnsignedlonglong(input, output, total);
        
#pragma mark - 小于8的数
        //        unsigned char input[] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66};
        //        int total = sizeof(input);
        //        unsigned long long output[1];
        //        //小于8的数
        //        convertUnsignedCharToUnsignedlonglong(input, output, total);
        
        
#pragma mark 大于8的数
        //        unsigned char input[] = {0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x33,0x44,0x55,0x66,0x33,0x44};
        //        int total = sizeof(input);
        ////        unsigned long long output[total/8 + 1];
        //        unsigned long long output[100];
        //
        //        //大于8的数
        //        convertUnsignedCharToUnsignedlonglong(input, output, total);
        
        
#pragma mark - unsigned char 类型的数据进行异或运算
#pragma mark - 异或运算(当异或运算的数据长度不一样时有补0)
        NSData * keyNSData = [@"fanyunfei" dataUsingEncoding:NSUTF8StringEncoding];
        unsigned char keyData [[keyNSData length]];
        memcpy(keyData, [keyNSData bytes], [keyNSData length]);
        
        NSData * inNSData = [@"daye" dataUsingEncoding:NSUTF8StringEncoding];
        unsigned char inData [[inNSData length]];
        memcpy(inData, [inNSData bytes], [inNSData length]);
        
        int  len = 0;
        if (sizeof(inNSData) >= sizeof(keyData))
        {
            len = (int)[inNSData length];
        }
        else
        {
            len = (int)[keyNSData length];
        }
        
        NSLog(@"原始数据:%@",inNSData);
        unsigned char outData [len];
        convertUnsignedCharToUnsignedChar(keyData, (int)[keyNSData length], inData, (int)[inNSData length], outData);
        NSLog(@"outData加密:%@",[NSData dataWithBytes:outData length:len]);
        
        convertUnsignedCharToUnsignedChar(keyData, (int)[keyNSData length], outData, len, outData);
        NSLog(@"outData解密:%@",[NSData dataWithBytes:outData length:len]);
        
#pragma mark - 异或运算(当异或运算的数据长度不一样时并没有补0)
        NIST_xor_encrypt(inData, keyData, (int)[inNSData length], (int)[keyNSData length]);
        NSLog(@"加密:%@",[NSData dataWithBytes:inData length:[inNSData length]]);
        NIST_xor_encrypt(inData, keyData, (int)[inNSData length], (int)[keyNSData length]);
        NSLog(@"解密:%@",[NSData dataWithBytes:inData length:[inNSData length]]);
        
    }
    return 0;
}

void  NIST_xor_encrypt(unsigned char * data, unsigned char * key, int dlen, int klen)
{
    for (long i = 0; i < dlen; i++)
    {
        data[i] = data[i] ^ key[(i % klen)];
    }
}

#pragma mark - ussigned char -> unsigned char
void convertUnsignedCharToUnsignedChar(unsigned char * key, int klen, unsigned char * intput, int ilen, unsigned char * output)
{
    if (ilen == klen)
    {
        for (int i = 0; i < ilen; i++)
        {
            intput[i] = intput[i] ^ key[i];
        }
        memcpy(output, intput, ilen);
    }
    if (ilen > klen)
    {
        unsigned char temp[ilen];
        unsigned char chong[1] = {0x00};
        unsigned char buchong[ilen - klen];
        for (int i = 0; i < ilen - klen; i++)
        {
            memcpy(buchong + i, chong, 1);
        }
        memcpy(temp, key, klen);
        memcpy(temp + klen, buchong, ilen - klen);
        
        for (int i = 0; i < ilen; i++)
        {
            intput[i] = intput[i] ^ temp[i];
        }
        memcpy(output, intput, ilen);
    }
    if (ilen < klen)
    {
        unsigned char temp[klen];
        unsigned char chong[1] = {0x00};
        unsigned char buchong[klen - ilen];
        for (int i = 0; i < klen - ilen; i++)
        {
            memcpy(buchong + i, chong, 1);
        }
        memcpy(temp, intput, ilen);
        memcpy(temp + ilen, buchong, klen - ilen);
        for (int i = 0; i < klen; i++)
        {
            temp[i] = temp[i] ^ key[i];
        }
        memcpy(output, temp, klen);
    }
}

#pragma mark - unsigned char -> unsigned long long
void convertUnsignedCharToUnsignedlonglong(unsigned char * input, unsigned long long * output, int len)
{
    /* 小于8的数 */
    if (len/8 == 0)
    {
        unsigned char tempput[8];
        /* 在此需要补充 8 - total 个字节的0x00 */
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
        memcpy(tempput, input, len);
        memcpy(tempput + len, buchong, 8 - len);
        memcpy(output, tempput, 8);
        for (int i = 0; i < 1; i++)
        {
            printf("%llx\n",output[i]);
        }
    }
    
    /* 8的整数倍 */
    if (len/8 >= 1 && (len%8) == 0)
    {
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
    
    /* 大于8的数 */
    if (len/8 >= 1 && (len%8) != 0)
    {
        unsigned char temp[8 * (len/8 + 1)];
        /* 在此需要补充 8 - total%8 个字节 */
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
        memcpy(temp, input, len);
        memcpy(temp + len, buchong, 8- len%8);
        memcpy(output, temp, 8 * (len/8 + 1));
        for (int i = 0; i < (len/8 + 1); i++)
        {
            printf("%llx\n",output[i]);
        }
    }
}

void unsignedchar2(unsigned char * input,unsigned long long  * output,int len )
{
    unsigned char temp[8 * (len/8 + 1)];
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
    memcpy(temp, input, len);
    memcpy(temp + len, buchong, 8- len%8);
    memcpy(output, temp, 8 * (len/8 + 1));
    for (int i = 0; i < (len/8 + 1); i++)
    {
        printf("%llx\n",output[i]);
    }
}

void unsignedchar1(unsigned char * input, unsigned long long * output,int len )
{
    unsigned char tempput[8];
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
    memcpy(tempput, input, len);
    memcpy(input + len, buchong, 8 - len);
    memcpy(output, tempput, 8);
    for (int i = 0; i < 1; i++)
    {
        printf("%llx\n",output[i]);
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
void convertUnsignedlonglongToUnsignedChar(unsigned long long * input, unsigned char * output, int len)
{
    memcpy(output, input, len);
}
