/**
 * \file des.h
 *
 * \brief DES block cipher
 *
 *  Copyright (C) 2006-2015, ARM Limited, All Rights Reserved
 *  SPDX-License-Identifier: Apache-2.0
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  This file is part of mbed TLS (https://tls.mbed.org)
 */
#ifndef MBEDTLS_DES_H
#define MBEDTLS_DES_H

#if !defined(MBEDTLS_CONFIG_FILE)
#include "config.h"
#else
#include MBEDTLS_CONFIG_FILE
#endif

#include <stddef.h>
#include <stdint.h>

#define MBEDTLS_DES_ENCRYPT     1
#define MBEDTLS_DES_DECRYPT     0

#define MBEDTLS_ERR_DES_INVALID_INPUT_LENGTH              -0x0032  /**< The data input has an invalid length. */

#define MBEDTLS_DES_KEY_SIZE    8

#if !defined(MBEDTLS_DES_ALT)
// Regular implementation
//

#ifdef __cplusplus
extern "C" {
#endif

/**
 * \brief          DES context structure
 */
typedef struct
{
    uint32_t sk[32];            /*!<  DES subkeys       */
}
mbedtls_des_context;

/**
 * \brief          Triple-DES context structure
 */
typedef struct
{
    uint32_t sk[96];            /*!<  3DES subkeys      */
}
mbedtls_des3_context;

/**
 * \brief          Initialize DES context
 *
 * \param ctx      DES context to be initialized
 */
void mbedtls_des_init( mbedtls_des_context *ctx );

/**
 * \brief          Clear DES context
 *
 * \param ctx      DES context to be cleared
 */
void mbedtls_des_free( mbedtls_des_context *ctx );

/**
 * \brief          DES key schedule (56-bit, encryption)
 *
 * \param ctx      DES context to be initialized
 * \param key      8-byte secret key
 *
 * \return         0
 */
int mbedtls_des_setkey_enc( mbedtls_des_context *ctx, const unsigned char key[MBEDTLS_DES_KEY_SIZE] );

/**
 * \brief          DES-ECB block encryption/decryption
 *
 * \param ctx      DES context
 * \param input    64-bit input block
 * \param output   64-bit output block
 *
 * \return         0 if successful
 */
int mbedtls_des_crypt_ecb( mbedtls_des_context *ctx,
                    const unsigned char input[8],
                    unsigned char output[8] );

/**
 * \brief          Internal function for key expansion.
 *                 (Only exposed to allow overriding it,
 *                 see MBEDTLS_DES_SETKEY_ALT)
 *
 * \param SK       Round keys
 * \param key      Base key
 */
void mbedtls_des_setkey( uint32_t SK[32],
                         const unsigned char key[MBEDTLS_DES_KEY_SIZE] );
#ifdef __cplusplus
}
#endif

#else  /* MBEDTLS_DES_ALT */
#include "des_alt.h"
#endif /* MBEDTLS_DES_ALT */

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
}
#endif

#endif /* des.h */
