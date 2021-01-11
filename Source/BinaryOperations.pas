{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{-------------------------------------------------------------------------------
 Binary operations.

 Lib.BinaryOperations is a Delphi/FPC/Lazarus library that provides function for
 uncommon binary operations.

 Version 0.1.3

 Copyright (c) 2018-2021, Piotr Domañski

 Last change:
   11-01-2021

 Changelog:
   For detailed changelog and history please refer to this git repository:
     https://github.com/dompiotr85/Lib.BinaryOperations

 Contacts:
   Piotr Domañski (dom.piotr.85@gmail.com)

 Dependencies:
   - JEDI common files (https://github.com/project-jedi/jedi)
   - Lib.TypeDefinitions (https://github.com/dompiotr85/Lib.TypeDefinitions)
   - Lib.CPUIdentification (https://github.com/dompiotr85/Lib.CPUIdentification)
     Required only when AllowASMExtensions symbol is defined and PurePascal
     symbol is not defined.
-------------------------------------------------------------------------------}

/// <summary>
///   Binary operations library that provides routines for uncommon binary
///   operations.
/// </summary>
unit BinaryOperations;

{$INCLUDE BinaryOperations.Config.inc}

{$IFDEF BO_PurePascal}
 {$DEFINE PurePascal}
{$ENDIF !BO_PurePascal}

{$IF DEFINED(CPU64) OR DEFINED(CPU64BITS)}
 {$DEFINE 64bit}
{$ELSEIF DEFINED(CPU16)}
 {$MESSAGE FATAL '16-bit CPU not supported!'}
{$ELSE}
 {$DEFINE 32bit}
{$IFEND}

{$IF DEFINED(CPUX86_64) OR DEFINED(CPUX64)}
 {$DEFINE x64}
{$ELSEIF DEFINED(CPU386)}
 {$DEFINE x86}
{$ELSE}
 {$DEFINE PurePascal}
{$IFEND}

{$IF DEFINED(WINDOWS) OR DEFINED(MSWINDOWS)}
 {$DEFINE Windows}
{$IFEND}

{$IFDEF FPC}
 {.$MODE Delphi}
 {$INLINE ON}
 {$DEFINE CanInline}
 {$IFNDEF PurePascal}
  {$ASMMODE Intel}
  {$DEFINE PurePascal}
 {$ENDIF}
 {$DEFINE FPC_DisableWarns}
 {$MACRO ON}
{$ELSE !FPC}
 {$IF CompilerVersion >= 17}  { Delphi 2005+ }
  {$DEFINE CanInline}
 {$ELSE}
  {$UNDEF CanInline}
 {$IFEND}
{$ENDIF}

{$H+}

{$IFOPT Q+}
 {$DEFINE OverflowChecks}
{$ENDIF}

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  TypeDefinitions;

{$IFDEF SUPPORTS_REGION}{$REGION 'Exception definitions'}{$ENDIF}
type
  EBOException = class(Exception);

  EBOUnknownFunction = class(EBOException);

  EBOConversionError = class(EBOException);
  EBOInvalidCharacter = class(EBOConversionError);
  EBOBufferTooSmall = class(EBOConversionError);
  EBOSizeMismatch = class(EBOConversionError);
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Integer number <-> Bit string conversions definition  - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Integer numbers <-> Bit string conversions definition'}{$ENDIF}
type
  TBitStringSplit = (bssNone, bss4bits, bss8bits, bss16bits, bss32bits);

  TBitStringFormat = record
    Split: TBitStringSplit;
    SetBitChar: Char;
    ZeroBitChar: Char;
    SplitChar: Char;
  end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

const
  DefBitStringFormat: TBitStringFormat = (
    Split: bssNone;
    SetBitChar: '1';
    ZeroBitChar: '0';
    SplitChar: ' ');

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt8; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function NumberToBitStr(Number: UInt16; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function NumberToBitStr(Number: UInt32; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function NumberToBitStr(Number: UInt64; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}

function NumberToBitStr(Number: UInt8; Split: TBitStringSplit): String; overload;
function NumberToBitStr(Number: UInt16; Split: TBitStringSplit): String; overload;
function NumberToBitStr(Number: UInt32; Split: TBitStringSplit): String; overload;
function NumberToBitStr(Number: UInt64; Split: TBitStringSplit): String; overload;

function NumberToBitStr(Number: UInt8): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function NumberToBitStr(Number: UInt16): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function NumberToBitStr(Number: UInt32): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function NumberToBitStr(Number: UInt64): String; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumber(const BitString: String; BitStringFormat: TBitStringFormat): UInt64; overload;
function BitStrToNumber(const BitString: String; Split: TBitStringSplit): UInt64; overload;
function BitStrToNumber(const BitString: String): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt8; BitStringFormat: TBitStringFormat): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt16; BitStringFormat: TBitStringFormat): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt32; BitStringFormat: TBitStringFormat): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt64; BitStringFormat: TBitStringFormat): Boolean; overload;

function TryBitStrToNumber(const BitString: String; out Value: UInt8; Split: TBitStringSplit): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt16; Split: TBitStringSplit): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt32; Split: TBitStringSplit): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt64; Split: TBitStringSplit): Boolean; overload;

function TryBitStrToNumber(const BitString: String; out Value: UInt8): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}
function TryBitStrToNumber(const BitString: String; out Value: UInt16): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}
function TryBitStrToNumber(const BitString: String; out Value: UInt32): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}
function TryBitStrToNumber(const BitString: String; out Value: UInt64): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumberDef(const BitString: String; Default: UInt64; BitStringFormat: TBitStringFormat): UInt64; overload;
function BitStrToNumberDef(const BitString: String; Default: UInt64; Split: TBitStringSplit): UInt64; overload;
function BitStrToNumberDef(const BitString: String; Default: UInt64): UInt64; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate left (ROL) definition  - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left (ROL) definition'}{$ENDIF}
function ROL(Value: UInt8; Shift: UInt8): UInt8; overload;
function ROL(Value: UInt16; Shift: UInt8): UInt16; overload;
function ROL(Value: UInt32; Shift: UInt8): UInt32; overload;
function ROL(Value: UInt64; Shift: UInt8): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ROLValue(var Value: UInt8; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ROLValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ROLValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ROLValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate right (ROR) definition - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right (ROR) definition'}{$ENDIF}
function ROR(Value: UInt8; Shift: UInt8): UInt8; overload;
function ROR(Value: UInt16; Shift: UInt8): UInt16; overload;
function ROR(Value: UInt32; Shift: UInt8): UInt32; overload;
function ROR(Value: UInt64; Shift: UInt8): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RORValue(var Value: UInt8; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RORValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RORValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RORValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate left with carry (RCL) definition - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left with carry (RCL) definition'}{$ENDIF}
function RCLCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8; overload;
function RCLCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16; overload;
function RCLCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32; overload;
function RCLCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCL(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCL(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCL(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCL(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate right with carry (RCR) definition  - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right with carry (RCR) definition'}{$ENDIF}
function RCRCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8; overload;
function RCRCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16; overload;
function RCRCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32; overload;
function RCRCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCR(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCR(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCR(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCR(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Arithmetic left shift (SAL) definition  - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic left shift (SAL) definition'}{$ENDIF}
function SAL(Value: UInt8; Shift: UInt8): UInt8; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function SAL(Value: UInt16; Shift: UInt8): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function SAL(Value: UInt32; Shift: UInt8): UInt32; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function SAL(Value: UInt64; Shift: UInt8): UInt64; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SALValue(var Value: UInt8; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SALValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SALValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SALValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Arithmetic right shift (SAR) definition - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic right shift (SAR) definition'}{$ENDIF}
function SAR(Value: UInt8; Shift: UInt8): UInt8; overload;
function SAR(Value: UInt16; Shift: UInt8): UInt16; overload;
function SAR(Value: UInt32; Shift: UInt8): UInt32; overload;
function SAR(Value: UInt64; Shift: UInt8): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SARValue(var Value: UInt8; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SARValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SARValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SARValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Endianity swap definition - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Endianity swap definition'}{$ENDIF}
function EndianSwap(Value: UInt16): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function EndianSwap(Value: UInt32): UInt32; overload;
function EndianSwap(Value: UInt64): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure EndianSwapValue(var Value: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure EndianSwapValue(var Value: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure EndianSwapValue(var Value: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure EndianSwap(var Buffer; Size: TMemSize); overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test (BT) definition  - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test (BT) definition'}{$ENDIF}
function BT(Value: UInt8; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function BT(Value: UInt16; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function BT(Value: UInt32; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function BT(Value: UInt64; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and set (BTS) definition - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set (BTS) definition'}{$ENDIF}
function BTS(var Value: UInt8; Bit: UInt8): ByteBool; overload;
function BTS(var Value: UInt16; Bit: UInt8): ByteBool; overload;
function BTS(var Value: UInt32; Bit: UInt8): ByteBool; overload;
function BTS(var Value: UInt64; Bit: UInt8): ByteBool; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and reset (BTR) definition - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and reset (BTR) definition'}{$ENDIF}
function BTR(var Value: UInt8; Bit: UInt8): ByteBool; overload;
function BTR(var Value: UInt16; Bit: UInt8): ByteBool; overload;
function BTR(var Value: UInt32; Bit: UInt8): ByteBool; overload;
function BTR(var Value: UInt64; Bit: UInt8): ByteBool; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and complement (BTC) definition  - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and complement (BTC) definition'}{$ENDIF}
function BTC(var Value: UInt8; Bit: UInt8): ByteBool; overload;
function BTC(var Value: UInt16; Bit: UInt8): ByteBool; overload;
function BTC(var Value: UInt32; Bit: UInt8): ByteBool; overload;
function BTC(var Value: UInt64; Bit: UInt8): ByteBool; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and set to a given value definition  - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set to a given value definition'}{$ENDIF}
function BitSetTo(var Value: UInt8; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
function BitSetTo(var Value: UInt16; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
function BitSetTo(var Value: UInt32; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
function BitSetTo(var Value: UInt64; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit scan forward (BSF) definition - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan forward (BSF) definition'}{$ENDIF}
function BSF(Value: UInt8): Int32; overload;
function BSF(Value: UInt16): Int32; overload;
function BSF(Value: UInt32): Int32; overload;
function BSF(Value: UInt64): Int32; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit scan reversed (BSR) definition  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan reversed (BSR) definition'}{$ENDIF}
function BSR(Value: UInt8): Int32; overload;
function BSR(Value: UInt16): Int32; overload;
function BSR(Value: UInt32): Int32; overload;
function BSR(Value: UInt64): Int32; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Population count definition - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Population count definition'}{$ENDIF}
function PopCount(Value: UInt8): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function PopCount(Value: UInt16): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function PopCount(Value: UInt32): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function PopCount(Value: UInt64): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Nibble manipulation definition  - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Nibble manipulation definition'}{$ENDIF}
function GetHighNibble(Value: UInt8): TNibble; {$IFDEF CanInline}inline;{$ENDIF}
function GetLowNibble(Value: UInt8): TNibble; {$IFDEF CanInline}inline;{$ENDIF}

function SetHighNibble(Value: UInt8; SetTo: TNibble): UInt8; {$IFDEF CanInline}inline;{$ENDIF}
function SetLowNibble(Value: UInt8; SetTo: TNibble): UInt8; {$IFDEF CanInline}inline;{$ENDIF}

procedure SetHighNibbleValue(var Value: UInt8; SetTo: TNibble); {$IFDEF CanInline}inline;{$ENDIF}
procedure SetLowNibbleValue(var Value: UInt8; SetTo: TNibble); {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Get flag state definition - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Get flag state definition'}{$ENDIF}
function GetFlagState(Value,FlagBitmask: UInt8; ExactMatch: Boolean = False): Boolean; overload;
function GetFlagState(Value,FlagBitmask: UInt16; ExactMatch: Boolean = False): Boolean; overload;
function GetFlagState(Value,FlagBitmask: UInt32; ExactMatch: Boolean = False): Boolean; overload;
function GetFlagState(Value,FlagBitmask: UInt64; ExactMatch: Boolean = False): Boolean; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Set flag definition - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag definition'}{$ENDIF}
{ Functions with bits noted in name (*_8, *_16, ...) are there mainly for older
  versions of Delphi (up to Delphi 2007), because they are not able to
  distinguish what overloaded function to call (some problem with open array
  parameter parsing). }

function SetFlag(Value, FlagBitmask: UInt8): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt16): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt32): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt64): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagValue(var Value: UInt8; FlagBitmask: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagValue(var Value: UInt16; FlagBitmask: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagValue(var Value: UInt32; FlagBitmask: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagValue(var Value: UInt64; FlagBitmask: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
function SetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
function SetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
function SetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags(Value: UInt8; Flags: array of UInt8): UInt8; overload;
function SetFlags(Value: UInt16; Flags: array of UInt16): UInt16; overload;
function SetFlags(Value: UInt32; Flags: array of UInt32): UInt32; overload;
function SetFlags(Value: UInt64; Flags: array of UInt64): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
procedure SetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
procedure SetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
procedure SetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue(var Value: UInt8; Flags: array of UInt8); overload;
procedure SetFlagsValue(var Value: UInt16; Flags: array of UInt16); overload;
procedure SetFlagsValue(var Value: UInt32; Flags: array of UInt32); overload;
procedure SetFlagsValue(var Value: UInt64; Flags: array of UInt64); overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Reset flag definition - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Reset flag definition'}{$ENDIF}
{ Functions with bits noted in name (*_8, *_16, ...) are there mainly for older
  versions of Delphi (up to Delphi 2007), because they are not able to
  distinguish what overloaded function to call (some problem with open array
  parameter parsing). }

function ResetFlag(Value, FlagBitmask: UInt8): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt16): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt32): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt64): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagValue(var Value: UInt8; FlagBitmask: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ResetFlagValue(var Value: UInt16; FlagBitmask: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ResetFlagValue(var Value: UInt32; FlagBitmask: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ResetFlagValue(var Value: UInt64; FlagBitmask: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
function ResetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
function ResetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
function ResetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags(Value: UInt8; Flags: array of UInt8): UInt8; overload;
function ResetFlags(Value: UInt16; Flags: array of UInt16): UInt16; overload;
function ResetFlags(Value: UInt32; Flags: array of UInt32): UInt32; overload;
function ResetFlags(Value: UInt64; Flags: array of UInt64): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
procedure ResetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
procedure ResetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
procedure ResetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue(var Value: UInt8; Flags: array of UInt8); overload;
procedure ResetFlagsValue(var Value: UInt16; Flags: array of UInt16); overload;
procedure ResetFlagsValue(var Value: UInt32; Flags: array of UInt32); overload;
procedure ResetFlagsValue(var Value: UInt64; Flags: array of UInt64); overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Set flag state definition - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag state definition'}{$ENDIF}
function SetFlagState(Value, FlagBitmask: UInt8; NewState: Boolean): UInt8; overload;
function SetFlagState(Value, FlagBitmask: UInt16; NewState: Boolean): UInt16; overload;
function SetFlagState(Value, FlagBitmask: UInt32; NewState: Boolean): UInt32; overload;
function SetFlagState(Value, FlagBitmask: UInt64; NewState: Boolean): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagStateValue(var Value: UInt8; FlagBitmask: UInt8; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagStateValue(var Value: UInt16; FlagBitmask: UInt16; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagStateValue(var Value: UInt32; FlagBitmask: UInt32; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagStateValue(var Value: UInt64; FlagBitmask: UInt64; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Get bits definition - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Get bits definition'}{$ENDIF}
{ Returns contiguous segment of bits from passed Value, selected by a bit
  range. }

function GetBits(Value: UInt8; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt8; overload;
function GetBits(Value: UInt16; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt16; overload;
function GetBits(Value: UInt32; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt32; overload;
function GetBits(Value: UInt64; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt64; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Set bits definition - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Set bits definition'}{$ENDIF}
{ Replaces contiguous segment of bits in Value by corresponding bits from
  NewBits. }

function SetBits(Value, NewBits: UInt8; FromBit, ToBit: Integer): UInt8; overload;
function SetBits(Value, NewBits: UInt16; FromBit, ToBit: Integer): UInt16; overload;
function SetBits(Value, NewBits: UInt32; FromBit, ToBit: Integer): UInt32; overload;
function SetBits(Value, NewBits: UInt64; FromBit, ToBit: Integer): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetBitsValue(var Value: UInt8; NewBits: UInt8; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetBitsValue(var Value: UInt16; NewBits: UInt16; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetBitsValue(var Value: UInt32; NewBits: UInt32; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetBitsValue(var Value: UInt64; NewBits: UInt64; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Reverse bits definition - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Reverse bits definition'}{$ENDIF}
function ReverseBits(Value: UInt8): UInt8; overload;
function ReverseBits(Value: UInt16): UInt16; overload;
function ReverseBits(Value: UInt32): UInt32; overload;
function ReverseBits(Value: UInt64): UInt64; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ReverseBitsValue(var Value: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ReverseBitsValue(var Value: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ReverseBitsValue(var Value: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ReverseBitsValue(var Value: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Leading zero count definition - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Leading zero count definition'}{$ENDIF}
function LZCount(Value: UInt8): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function LZCount(Value: UInt16): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function LZCount(Value: UInt32): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function LZCount(Value: UInt64): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Trailing zero count definition  - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Trailing zero count definition'}{$ENDIF}
function TZCount(Value: UInt8): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function TZCount(Value: UInt16): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function TZCount(Value: UInt32): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function TZCount(Value: UInt64): Int32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Extract bits definition - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Extract bits definition'}{$ENDIF}
function ExtractBits(Value: UInt8; Start, Length: UInt8): UInt8; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ExtractBits(Value: UInt16; Start, Length: UInt8): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ExtractBits(Value: UInt32; Start, Length: UInt8): UInt32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ExtractBits(Value: UInt64; Start, Length: UInt8): UInt64; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Parallel bits extract definition  - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits extract definition'}{$ENDIF}
function ParallelBitsExtract(Value, Mask: UInt8): UInt8; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ParallelBitsExtract(Value, Mask: UInt16): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ParallelBitsExtract(Value, Mask: UInt32): UInt32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ParallelBitsExtract(Value, Mask: UInt64): UInt64; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Parallel bits deposit definition  - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits deposit definition'}{$ENDIF}
function ParallelBitsDeposit(Value, Mask: UInt8): UInt8; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ParallelBitsDeposit(Value, Mask: UInt16): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ParallelBitsDeposit(Value, Mask: UInt32): UInt32; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
function ParallelBitsDeposit(Value, Mask: UInt64): UInt64; overload; {$IF DEFINED(CanInline) AND DEFINED(FPC)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- General data <-> Hex string conversions definition  - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'General data <-> Hex string conversions definition'}{$ENDIF}
type
  THexStringSplit = (
    hssNone, hssNibble, hssByte, hssWord, hss24bits, hssLong, hssQuad, hss80bits, hssOcta);

  THexStringFormat = record
    Split: THexStringSplit;
    SplitChar: Char;
    UpperCase: Boolean;
  end;

const
  DefHexStringFormat: THexStringFormat = (
    Split: hssNone;
    SplitChar: ' ';
    UpperCase: True);

type
  TArrayOfBytes = packed array of UInt8;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(const Buffer; Size: TMemSize; HexStringFormat: THexStringFormat): String; overload;
function DataToHexStr(Arr: array of UInt8; HexStringFormat: THexStringFormat): String; overload;

function DataToHexStr(const Buffer; Size: TMemSize; Split: THexStringSplit): String; overload;
function DataToHexStr(Arr: array of UInt8; Split: THexStringSplit): String; overload;

function DataToHexStr(const Buffer; Size: TMemSize): String; overload; {$IFDEF Inline}inline;{$ENDIF}
function DataToHexStr(Arr: array of UInt8): String; overload; {$IFDEF Inline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String; out Buffer; Size: TMemSize; HexStringFormat: THexStringFormat): TMemSize; overload;
function HexStrToData(const Str: String; HexStringFormat: THexStringFormat): TArrayOfBytes; overload;

function HexStrToData(const Str: String; out Buffer; Size: TMemSize; Split: THexStringSplit): TMemSize; overload;
function HexStrToData(const Str: String; Split: THexStringSplit): TArrayOfBytes; overload;

function HexStrToData(const Str: String; out Buffer; Size: TMemSize): TMemSize; overload; {$IFDEF Inline}inline;{$ENDIF}
function HexStrToData(const Str: String): TArrayOfBytes; overload; {$IFDEF Inline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Buffer; var Size: TMemSize; HexStringFormat: THexStringFormat): Boolean; overload;
function TryHexStrToData(const Str: String; out Arr: TArrayOfBytes; HexStringFormat: THexStringFormat): Boolean; overload;

function TryHexStrToData(const Str: String; out Buffer; var Size: TMemSize; Split: THexStringSplit): Boolean; overload;
function TryHexStrToData(const Str: String; out Arr: TArrayOfBytes; Split: THexStringSplit): Boolean; overload;

function TryHexStrToData(const Str: String; out Buffer; var Size: TMemSize): Boolean; overload; {$IFDEF Inline}inline;{$ENDIF}
function TryHexStrToData(const Str: String; out Arr: TArrayOfBytes): Boolean; overload; {$IFDEF Inline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Binary data comparison definition - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Binary data comparison definition'}{$ENDIF}
{ If the two data samples differ in size, and AllowSizeDiff is set to True,
  then CompareData will return negative number when sample A is shorter than
  sample B, positive number otherwise, irrespective of actual data. If the
  AllowSizeDiff parameter is set to False, the function will raise an exception
  of type EBOSizeMismatch.

  If the samples hawe equal size, the data are compared byte-by-byte. The bytes
  are not summed or processed in any way, they are merely compared. When first
  two differing bytes are encountered, they are compared, result is set
  accordingly and traversing is immediately terminated.
  If the byte in first sample is smaller than byte in the second sample, then
  result will be set to a negative number, otherwise it will be set to a
  positive number.

  If both the data have the same size and contains the same bytestream, then
  CompareData returns zero. }

function CompareData(const A; SizeA: TMemSize; const B; SizeB: TMemSize; AllowSizeDiff: Boolean = True): Integer; overload;
function CompareData(A, B: array of UInt8; AllowSizeDiff: Boolean = True): Integer; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Binary data equality definition - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Binary data equality definition'}{$ENDIF}
{ If the two data samples differ in size, SameData will return False,
  irrespective of actual content.
  If both data have zero size, it will return True. }

function SameData(const A; SizeA: TMemSize; const B; SizeB: TMemSize): Boolean; overload;
function SameData(A, B: array of UInt8): Boolean; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit parity definition - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit parity definition'}{$ENDIF}
{ Bit parity returns True when the number contain an even number or zero set
  bits, False otherwise. }

function BitParity(Value: UInt8): Boolean; overload;
function BitParity(Value: UInt16): Boolean; overload;
function BitParity(Value: UInt32): Boolean; overload;
function BitParity(Value: UInt64): Boolean; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Unit implementation info definition - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Unit implementation info definition'}{$ENDIF}
type
  TBitOpsFunctions = (
    fnPopCount8, fnPopCount16, fnPopCount32, fnPopCount64,
    fnLZCount8, fnLZCount16, fnLZCount32, fnLZCount64,
    fnTZCount8, fnTZCount16, fnTZCount32, fnTZCount64,
    fnExtractBits8, fnExtractBits16, fnExtractBits32, fnExtractBits64,
    fnParallelBitsExtract8, fnParallelBitsExtract16,
    fnParallelBitsExtract32, fnParallelBitsExtract64,
    fnParallelBitsDeposit8, fnParallelBitsDeposit16,
    fnParallelBitsDeposit32, fnParallelBitsDeposit64);

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Returns True when selected function is currently set to asm-implemented
///   code, False otherwise.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function BitOpsFunctionIsAsm(Func: TBitOpsFunctions): Boolean;

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Routes selected function to pascal implementation.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure BitOpsFunctionPas(Func: TBitOpsFunctions);

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Routes selected function to assembly implementation. Does nothing when
///   PurePascal symbol is defined.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure BitOpsFunctionAsm(Func: TBitOpsFunctions);

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Calls BitOpsFunctionAsm for selected function when AssignASM is set to
///   True and PurePascal symbol is NOT defined, otherwise it calls
///   BitOpsFunctionPas.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure BitOpsFunctionAssign(Func: TBitOpsFunctions; AssignASM: Boolean);
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
{$IF DEFINED(BO_AllowASMExtensions) AND NOT DEFINED(PurePascal)}
  CPUIdentification,
{$IFEND}
  BinaryOperations.Consts;

{$IFDEF FPC_DisableWarns}
 {$DEFINE FPCDWM}
{ Conversion between ordinals and pointers is not portable. }
 {$DEFINE W4055:={$WARN 4055 OFF}}
{ Conversion between ordinals and pointers is not portable. }
 {$DEFINE W4056:={$WARN 4056 OFF}}
{ Parameter "$1" not used. }
 {$DEFINE W5024:={$WARN 5024 OFF}}
{ Variable "$1" does not seem to be initialized. }
 {$DEFINE W5058:={$WARN 5058 OFF}}
{$ENDIF !FPC_DisableWarns}

{$IFNDEF FPC}
const
  FPC_VERSION = 0;
{$ENDIF !FPC}

{$IF (NOT DEFINED(FPC) AND NOT DEFINED(x64)) OR (FPC_VERSION < 3)}
{ ASM_MachineCode

  When defined, some ASM instructions are inserted into byte stream directly as
  a machine code. It is there because not all compilers supports, and therefore
  can compile, such instructions.
  As I am not able to tell which 32-bit delphi compilers do support them, I am
  assuming none of them do. I am also assuming that all 64-bit delphi compilers
  and current FPCs are supporting the instructions. Has no effect when
  PurePascal is defined. }
 {$DEFINE ASM_MachineCode}
{$IFEND}

{- Integer number <-> Bit string conversions implementation  - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Integer number <-> Bit string conversions implementation'}{$ENDIF}
function NumberToBitString(Number: UInt64; Bits: UInt8; BitStringFormat: TBitStringFormat): String;
var
  I, SplitCnt: Integer;
begin
  case BitStringFormat.Split of
    bss4bits:
      SplitCnt := 4;

    bss8bits:
      SplitCnt := 8;

    bss16bits:
      SplitCnt := 16;

    bss32bits:
      SplitCnt := 32;

    else
      SplitCnt := Bits;
  end;

  if (SplitCnt > Bits) then
    SplitCnt := Bits;

  Result := StringOfChar(BitStringFormat.ZeroBitChar, Bits + (Pred(Bits) div SplitCnt));

  for I := Bits downto 1 do
  begin
    if ((Number and 1) <> 0) then
      Result[I + (Pred(I) div SplitCnt)] := BitStringFormat.SetBitChar;

    Number := Number shr 1;
  end;

  for I := 1 to Pred(Bits div SplitCnt) do
    Result[(I * SplitCnt) + I] := BitStringFormat.SplitChar;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt8; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 8, BitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt16; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 16, BitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt32; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 32, BitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt64; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 64, BitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt8; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt16; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt32; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt64; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt8): String;
begin
  Result := NumberToBitString(Number, 8, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt16): String;
begin
  Result := NumberToBitString(Number, 16, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt32): String;
begin
  Result := NumberToBitString(Number, 32, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumberToBitStr(Number: UInt64): String;
begin
  Result := NumberToBitString(Number, 64, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumber(const BitString: String; BitStringFormat: TBitStringFormat): UInt64;
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to Length(BitString) do
  begin
    if (BitString[I] <> BitStringFormat.SplitChar) then
    begin
      Result := Result shl 1;

      if (BitString[I] = BitStringFormat.SetBitChar) then
        Result := Result or 1
      else
        if (BitString[I] <> BitStringFormat.ZeroBitChar) then
          raise EBOInvalidCharacter.CreateFmt(SBitStrToNumber_UnknownCharacterInBitstring, [Ord(BitString[I])]);
    end else
      Continue{for I};
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumber(const BitString: String; Split: TBitStringSplit): UInt64;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := BitStrToNumber(BitString, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumber(const BitString: String): UInt64;
begin
  Result := BitStrToNumber(BitString, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt8; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := UInt8(BitStrToNumber(BitString, BitStringFormat));
    Result := True;
  except
    Result := False;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt16; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := UInt16(BitStrToNumber(BitString, BitStringFormat));
    Result := True;
  except
    Result := False;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt32; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := UInt32(BitStrToNumber(BitString, BitStringFormat));
    Result := True;
  except
    Result := False;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt64; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := BitStrToNumber(BitString, BitStringFormat);
    Result := True;
  except
    Result := False;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt8; Split: TBitStringSplit): Boolean;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := TryBitStrToNumber(BitString, Value, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt16; Split: TBitStringSplit): Boolean;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := TryBitStrToNumber(BitString, Value, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt32; Split: TBitStringSplit): Boolean;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := TryBitStrToNumber(BitString, Value, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt64; Split: TBitStringSplit): Boolean;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := TryBitStrToNumber(BitString, Value, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt8): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt16): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt32): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryBitStrToNumber(const BitString: String; out Value: UInt64): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumberDef(const BitString: String; Default: UInt64; BitStringFormat: TBitStringFormat): UInt64;
begin
  if (not TryBitStrToNumber(BitString, Result, BitStringFormat)) then
    Result := Default;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumberDef(const BitString: String; Default: UInt64; Split: TBitStringSplit): UInt64;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  if (not TryBitStrToNumber(BitString, Result, Format)) then
    Result := Default;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitStrToNumberDef(const BitString: String; Default: UInt64): UInt64;
begin
  if (not TryBitStrToNumber(BitString, Result, DefBitStringFormat)) then
    Result := Default;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate left (ROL) implementation  - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left (ROL) implementation'}{$ENDIF}
function ROL(Value: UInt8; Shift: UInt8): UInt8; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AL, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  ROL         AL, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $07;
  Result := UInt8((Value shl Shift) or (Value shr (8 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ROL(Value: UInt16; Shift: UInt8): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  ROL         AX, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $0F;
  Result := UInt16((Value shl Shift) or (Value shr (16 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ROL(Value: UInt32; Shift: UInt8): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  ROL         EAX, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $1F;
  Result := UInt32((Value shl Shift) or (Value shr (32 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ROL(Value: UInt64; Shift: UInt8): UInt64; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  MOV         CL, Shift
  ROL         RAX, CL
 {$ELSE !x64}
  MOV         ECX, EAX
  AND         ECX, $3F
  CMP         ECX, 32

  JAE   @Above31

@Below32:
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]
  CMP         ECX, 0
  JE          @FuncEnd

  MOV         dword ptr [Value], EDX
  JMP         @Rotate

@Above31:
  MOV         EDX, dword ptr [Value]
  MOV         EAX, dword ptr [Value + 4]
  JE          @FuncEnd

  AND         ECX, $1F

@Rotate:
  SHLD        EDX, EAX, CL
  SHL         EAX,  CL
  PUSH        EAX
  MOV         EAX, dword ptr [Value]
  XOR         CL, 31
  INC         CL
  SHR         EAX, CL
  POP         ECX
  OR          EAX,  ECX

@FuncEnd:
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $3F;
  Result := UInt64((Value shl Shift) or (Value shr (64 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ROLValue(var Value: UInt8; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ROLValue(var Value: UInt16; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ROLValue(var Value: UInt32; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ROLValue(var Value: UInt64; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate right (ROR) implementation - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right (ROR) implementation'}{$ENDIF}
function ROR(Value: UInt8; Shift: UInt8): UInt8; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AL, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  ROR         AL, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $07;
  Result := UInt8((Value shr Shift) or (Value shl (8 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ROR(Value: UInt16; Shift: UInt8): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  ROR         AX, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $0F;
  Result := UInt16((Value shr Shift) or (Value shl (16 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ROR(Value: UInt32; Shift: UInt8): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  ROR         EAX, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $1F;
  Result := UInt32((Value shr Shift) or (Value shl (32 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ROR(Value: UInt64; Shift: UInt8): UInt64; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  MOV         CL, Shift
  ROR         RAX, CL
 {$ELSE !x64}
  MOV         ECX, EAX
  AND         ECX, $3F
  CMP         ECX, 32

  JAE         @Above31

@Below32:
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]
  CMP         ECX, 0
  JE          @FuncEnd

  MOV         dword ptr [Value], EDX
  JMP         @Rotate

@Above31:
  MOV         EDX, dword ptr [Value]
  MOV         EAX, dword ptr [Value + 4]
  JE          @FuncEnd

  AND         ECX, $1F

@Rotate:
  SHRD        EDX, EAX, CL
  SHR         EAX, CL
  PUSH        EAX
  MOV         EAX, dword ptr [Value]
  XOR         CL, 31
  INC         CL
  SHL         EAX, CL
  POP         ECX
  OR          EAX, ECX

@FuncEnd:
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $3F;
  Result := UInt64((Value shr Shift) or (Value shl (64 - Shift)));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RORValue(var Value: UInt8; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RORValue(var Value: UInt16; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RORValue(var Value: UInt32; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RORValue(var Value: UInt64; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate left with carry (RCL) implementation - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left with carry (RCL) implementation'}{$ENDIF}
function RCLCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AL, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCL         AL, CL
  SETC        byte ptr [CF]
 {$ELSE !x64}
  XCHG        EDX, ECX
  SHR         byte ptr [EDX], 1
  RCL         AL, CL
  SETC        byte ptr [EDX]
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $07;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result shr 7) <> 0;
    Result := UInt8((Result shl 1) or (UInt8(Carry) and UInt8(1)));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCLCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCL         AX, CL
  SETC        byte ptr [CF]
 {$ELSE !x64}
  XCHG        EDX, ECX
  SHR         byte ptr [EDX], 1
  RCL         AX, CL
  SETC        byte ptr [EDX]
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $0F;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result shr 15) <> 0;
    Result := UInt16((Result shl 1) or (UInt16(Carry) and UInt16(1)));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCLCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCL         EAX, CL
  SETC        byte ptr [CF]
 {$ELSE !x64}
  XCHG        EDX, ECX
  SHR         byte ptr [EDX], 1
  RCL         EAX, CL
  SETC        byte ptr [EDX]
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $1F;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result shr 31) <> 0;
    Result := UInt32((Result shl 1) or (UInt32(Carry) and 1));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCLCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64; {$IFNDEF PurePascal}register; assembler;
 {$IFDEF x64}
asm
  MOV         RAX, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCL         RAX, CL
  SETC        byte ptr [CF]
end;
 {$ELSE !x64}
var
  TempShift: UInt32;
asm
  PUSH        EBX

  AND         EAX, $3F
  MOV         dword ptr [TempShift], EAX
  MOV         ECX, EAX
  MOV         EBX, EDX

  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]
  CMP         ECX, 32

  JE          @Exactly32
  JA          @Above32

  { Shift is below 32. }
  TEST        ECX, ECX
  JZ          @FuncEnd

  SHLD        EDX, EAX, CL
  JMP         @Shift

  { Shift is above 32. }
@Above32:
  AND         ECX, $1F

  DEC         CL
  SHLD        EDX, EAX, CL
  INC         CL

  { Main shifting. }
@Shift:
  SHL         EAX, CL
  PUSH        ECX
  PUSH        EAX
  MOV         EAX, dword ptr [Value + 4]
  SHR         EAX, 2
  XOR         CL, 31
  SHR         EAX, CL
  POP         ECX
  OR          EAX, ECX
  POP         ECX
  JMP         @SetCarry

  { Shift is equal to 32, no shifting required, only swap Hi and Lo dwords. }
@Exactly32:
  SHR         EDX, 1
  XCHG        EAX, EDX

  { Write passed carry bit to the result. }
@SetCarry:
  DEC         ECX
  CMP         byte ptr [EBX], 0
  JE          @ResetBit

  BTS         EAX, ECX
  JMP         @Swap

@ResetBit:
  BTR         EAX, ECX

  { Swap Hi and Lo dwords for shift > 32. }
@Swap:
  CMP         byte ptr [TempShift], 32
  JBE         @GetCarry
  XCHG        EAX, EDX

  { Get carry bit that will be output in CF parameter. }
@GetCarry:
  MOV         CL, byte ptr [TempShift]
  AND         ECX, $3F
  CMP         CL, 32
  JBE         @FromHigh

  AND         CL, $1F
  DEC         CL
  XOR         CL, 31
  BT          dword ptr [Value], ECX
  JMP         @StoreCarry

@FromHigh:
  DEC         CL
  XOR         CL, 31
  BT          dword ptr [Value + 4], ECX

@StoreCarry:
  SETC        CL
  MOV         byte ptr [EBX], CL

  { Restore EBX register. }
@FuncEnd:
  POP         EBX
end;
 {$ENDIF !x64}
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $3F;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result shr 63) <> 0;
    Result := UInt64((Result shl 1) or (UInt64(Carry) and 1));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCL(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8;
begin
  Result := RCLCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCL(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16;
begin
  Result := RCLCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCL(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32;
begin
  Result := RCLCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCL(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64;
begin
  Result := RCLCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCLValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Rotate right with carry (RCR) implementation  - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right with carry (RCR) implementation'}{$ENDIF}
function RCRCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AL, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCR         AL, CL
  SETC        byte ptr [CF]
 {$ELSE !x64}
  XCHG        EDX, ECX
  SHR         byte ptr [EDX], 1
  RCR         AL, CL
  SETC        byte ptr [EDX]
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $07;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result and 1) <> 0;
    Result := UInt8((Result shr 1) or ((UInt8(Carry) and UInt8(1)) shl 7));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCRCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCR         AX, CL
  SETC        byte ptr [CF]
 {$ELSE !x64}
  XCHG        EDX, ECX
  SHR         byte ptr [EDX], 1
  RCR         AX, CL
  SETC        byte ptr [EDX]
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $0F;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result and 1) <> 0;
    Result := UInt16((Result shr 1) or ((UInt16(Carry) and UInt16(1)) shl 15));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCRCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCR         EAX, CL
  SETC        byte ptr [CF]
 {$ELSE !x64}
  XCHG        EDX, ECX
  SHR         byte ptr [EDX], 1
  RCR         EAX, CL
  SETC        byte ptr [EDX]
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $1F;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result and 1) <> 0;
    Result := UInt32((Result shr 1) or ((UInt32(Carry) and 1) shl 31));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function RCRCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64; {$IFNDEF PurePascal}register; assembler;
 {$IFDEF x64}
asm
  MOV         RAX, Value
  MOV         CL, Shift
  SHR         byte ptr [CF], 1
  RCR         RAX, CL
  SETC        byte ptr [CF]
end;
 {$ELSE !x64}
var
  TempShift: UInt32;
asm
  PUSH        EBX

  AND         EAX, $3F
  MOV         dword ptr [TempShift], EAX
  MOV         ECX, EAX
  MOV         EBX, EDX

  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]
  CMP         ECX, 32

  JE          @Exactly32
  JA          @Above32

  { Shift is below 32. }
  TEST        ECX, ECX
  JZ          @FuncEnd

  SHRD        EAX, EDX, CL
  JMP         @Shift

  { Shift is above 32. }
@Above32:
  AND         ECX, $1F

  DEC         CL
  SHRD        EAX, EDX, CL
  INC         CL

  { Main shifting. }
@Shift:
  SHR         EDX, CL
  PUSH        ECX
  PUSH        EDX
  MOV         EDX, dword ptr [Value]
  SHL         EDX, 2
  XOR         CL, 31
  SHL         EDX, CL
  POP         ECX
  OR          EDX, ECX
  POP         ECX
  JMP         @SetCarry

  { Shift is equal to 32, no shifting required, only swap Hi and Lo dwords. }
@Exactly32:
  SHL         EAX, 1
  XCHG        EAX, EDX

  { Write passed carry bit to the result. }
@SetCarry:
  DEC         ECX
  XOR         ECX, 31
  CMP         byte ptr [EBX], 0
  JE          @ResetBit

  BTS         EDX, ECX
  JMP         @Swap

@ResetBit:
  BTR         EDX, ECX

  { Swap Hi and Lo dwords for shift > 32. }
@Swap:
  CMP         byte ptr [TempShift], 32
  JBE         @GetCarry
  XCHG        EAX, EDX

  { Get carry bit that will be output in CF parameter. }
@GetCarry:
  MOV         CL, byte ptr [TempShift]
  AND         ECX, $3F
  CMP         CL, 32
  JA          @FromHigh

  DEC         CL
  BT          dword ptr [Value], ECX
  JMP         @StoreCarry

@FromHigh:
  AND         CL, $1F
  DEC         CL
  BT          dword ptr [Value + 4], ECX

@StoreCarry:
  SETC        CL
  MOV         byte ptr [EBX], CL

  { Restore EBX register. }
@FuncEnd:
  POP         EBX
end;
 {$ENDIF !x64}
{$ELSE !PurePascal}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $3F;
  Carry := CF;
  Result := Value;

  for I := 1 to Shift do
  begin
    CF := (Result and 1) <> 0;
    Result := UInt64((Result shr 1) or ((UInt64(Carry) and 1) shl 63));
    Carry := CF;
  end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCR(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8;
begin
  Result := RCRCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCR(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16;
begin
  Result := RCRCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCR(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32;
begin
  Result := RCRCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function RCR(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64;
begin
  Result := RCRCarry(Value, Shift, CF);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure RCRValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Arithmetic left shift (SAL) implementation  - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic left shift (SAL) implementation'}{$ENDIF}
function SAL(Value: UInt8; Shift: UInt8): UInt8; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AL, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  SAL         AL, CL
end;
{$ELSE !PurePascal}
begin
  Result := UInt8(Value shl Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SAL(Value: UInt16; Shift: UInt8): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  SAL         AX, CL
end;
{$ELSE !PurePascal}
begin
  Result := UInt16(Value shl Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SAL(Value: UInt32; Shift: UInt8): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  SAL         EAX, CL
end;
{$ELSE !PurePascal}
begin
  Result := UInt32(Value shl Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SAL(Value: UInt64; Shift: UInt8): UInt64; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  MOV         CL, Shift
  SAL         RAX, CL
 {$ELSE !x64}
  MOV         ECX, EAX
  AND         ECX, $3F

  CMP         ECX, 31
  JA    @Above31

  { Shift is below 32. }
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]

  TEST        ECX, ECX
  JZ          @FuncEnd

  SHLD        EDX, EAX, CL
  SHL         EAX, CL
  JMP         @FuncEnd

  { Shift is above 31. }
 @Above31:
  XOR         EAX, EAX
  MOV         EDX, dword ptr [Value]
  AND         ECX, $1F
  SHL         EDX, CL

  { End of the function. }
  @FuncEnd:
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
begin
  Result := UInt64(Value shl Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SALValue(var Value: UInt8; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SALValue(var Value: UInt16; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SALValue(var Value: UInt32; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SALValue(var Value: UInt64; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Arithmetic right shift (SAR) implementation - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic right shift (SAR) implementation'}{$ENDIF}
function SAR(Value: UInt8; Shift: UInt8): UInt8; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AL, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  SAR         AL, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $07;
  if ((Value shr 7) <> 0) then
    Result := UInt8((Value shr Shift) or (UInt8($FF) shl (8 - Shift)))
  else
    Result := UInt8(Value shr Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SAR(Value: UInt16; Shift: UInt8): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  SAR         AX, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $0F;

  if ((Value shr 15) <> 0) then
    Result := UInt16((Value shr Shift) or (UInt16($FFFF) shl (16 - Shift)))
  else
    Result := UInt16(Value shr Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SAR(Value: UInt32; Shift: UInt8): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
  MOV         CL, Shift
  SAR         EAX, CL
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $1F;

  if ((Value shr 31) <> 0) then
    Result := UInt32((Value shr Shift) or (UInt32($FFFFFFFF) shl (32 - Shift)))
  else
    Result := UInt32(Value shr Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SAR(Value: UInt64; Shift: UInt8): UInt64; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  MOV         CL, Shift
  SAR         RAX, CL
 {$ELSE !x64}
  MOV         ECX, EAX
  AND         ECX, $3F

  CMP         ECX, 31
  JA          @Above31

  { Shift is below 32. }
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]

  TEST        ECX, ECX
  JZ          @FuncEnd

  SHRD        EAX, EDX, CL
  SAR         EDX, CL
  JMP         @FuncEnd

  { Shift is above 31. }
 @Above31:
  MOV         EAX, dword ptr [Value + 4]
  BT          EAX, 31
  JC          @BitSet

  XOR         EDX, EDX
  JMP         @DoShift

@BitSet:
  MOV         EDX, $FFFFFFFF

@DoShift:
  AND         ECX, $1F
  SAR         EAX, CL

  { End of the function. }
@FuncEnd:
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
begin
  Shift := Shift and $3F;

  if ((Value shr 63) <> 0) then
    Result := UInt64((Value shr Shift) or (UInt64($FFFFFFFFFFFFFFFF) shl (64 - Shift)))
  else
    Result := UInt64(Value shr Shift);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SARValue(var Value: UInt8; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SARValue(var Value: UInt16; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SARValue(var Value: UInt32; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SARValue(var Value: UInt64; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Endianity swap implementation - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Endianity swap implementation'}{$ENDIF}
function EndianSwap(Value: UInt16): UInt16; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         AX, Value
 {$ENDIF !x64}
  XCHG        AL, AH
end;
{$ELSE !PurePascal}
begin
  Result := UInt16((Value shl 8) or (Value shr 8));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function EndianSwap(Value: UInt32): UInt32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
  BSWAP       EAX
end;
{$ELSE !PurePascal}
begin
  Result :=
    UInt32(((Value and $000000FF) shl 24) or ((Value and $0000FF00) shl 8) or
           ((Value and $00FF0000) shr 8) or ((Value and $FF000000) shr 24));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function EndianSwap(Value: UInt64): UInt64; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  BSWAP       RAX
 {$ELSE !x64}
  MOV         EAX, dword ptr [Value + 4]
  MOV         EDX, dword ptr [Value]
  BSWAP       EAX
  BSWAP       EDX
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
begin
  Int64Rec(Result).Hi := EndianSwap(Int64Rec(Value).Lo);
  Int64Rec(Result).Lo := EndianSwap(Int64Rec(Value).Hi);
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure EndianSwapValue(var Value: UInt16);
begin
  Value := EndianSwap(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure EndianSwapValue(var Value: UInt32);
begin
  Value := EndianSwap(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure EndianSwapValue(var Value: UInt64);
begin
  Value := EndianSwap(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure EndianSwap(var Buffer; Size: TMemSize); {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  XCHG        RCX, RDX
  {$ELSE !Windows}
  MOV         RDX, RDI
  MOV         RCX, RSI
  {$ENDIF !Windows}

  CMP         RCX, 1
  JBE         @RoutineEnd

  LEA         RAX, [RDX + RCX - 1]
  SHR         RCX, 1

@LoopStart:
  MOV         R8B, byte ptr [RDX]
  MOV         R9B, byte ptr [RAX]
  MOV         byte ptr [RAX], R8B
  MOV         byte ptr [RDX], R9B
  INC         RDX
  DEC         RAX

  DEC         RCX
  JNZ         @LoopStart

@RoutineEnd:
 {$ELSE !x64}
  MOV         ECX, EDX
  CMP         ECX, 1
  JBE         @RoutineEnd

  PUSH        ESI
  PUSH        EDI

  MOV         ESI, EAX
  LEA         EDI, [EAX + ECX - 1]
  SHR         ECX, 1

@LoopStart:
  MOV         AL, byte ptr [ESI]
  MOV         DL, byte ptr [EDI]
  MOV         byte ptr [EDI], AL
  MOV         byte ptr [ESI], DL
  INC         ESI
  DEC         EDI

  DEC         ECX
  JNZ         @LoopStart

  POP         EDI
  POP         ESI

@RoutineEnd:
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: TMemSize;
  ByteBuff: Byte;
begin
  case Size of
    Low(Size)..1:
      Exit;

    2:
      EndianSwapValue(UInt16(Buffer));

    4:
      EndianSwapValue(UInt32(Buffer));

    8:
      EndianSwapValue(UInt64(Buffer));

    else
      for I := 0 to Pred(Size div 2) do
      begin
{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
        ByteBuff := PByte(PtrUInt(Addr(Buffer)) + i)^;
        PByte(PtrUInt(Addr(Buffer)) + i)^ := PByte(PtrUInt(Addr(Buffer)) + (Size - i - 1))^;
        PByte(PtrUInt(Addr(Buffer)) + (Size - i - 1))^ := ByteBuff;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
      end;
  end;
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test (BT) implementation  - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test (BT) implementation'}{$ENDIF}
function BT(Value: UInt8; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $7
  BT          CX, DX
  {$ELSE !Windows}
  AND         SI, $7
  BT          DI, SI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $7
  BT          AX, DX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BT(Value: UInt16; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BT          CX, DX
  {$ELSE !Windows}
  BT          DI, SI
  {$ENDIF !Windows}
 {$ELSE !x64}
  BT          AX, DX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BT(Value: UInt32; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BT          ECX, EDX
  {$ELSE !Windows}
  BT          EDI, ESI
  {$ENDIF !Windows}
 {$ELSE !x64}
  BT          EAX, EDX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BT(Value: UInt64; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BT          RCX, RDX
  {$ELSE !Windows}
  BT          RDI, RSI
  {$ENDIF !Windows}
 {$ELSE !x64}
  CMP         EAX, 32
  JAE         @TestHigh

  BT          dword ptr [Value], EAX
  JMP         @SetResult

@TestHigh:
  AND         EAX, $1F
  BT          dword ptr [Value + 4], EAX
 {$ENDIF !x64}
@SetResult:
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and set (BTS) implementation - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set (BTS) implementation'}{$ENDIF}
function BTS(var Value: UInt8; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $7
  MOVZX       RAX, byte ptr [RCX]
  BTS         AX, DX
  MOV         byte ptr [RCX], AL
  {$ELSE !Windows}
  AND         SI, $7
  MOVZX       RAX, byte ptr [RDI]
  BTS         AX, SI
  MOV         byte ptr [RDI], AL
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $7
  MOVZX       ECX, byte ptr [EAX]
  BTS         CX, DX
  MOV         byte ptr [EAX], CL
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt8(Value or (UInt8(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTS(var Value: UInt16; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $FF
  BTS         word ptr [RCX], DX
  {$ELSE !Windows}
  AND         SI, $FF
  BTS         word ptr [RDI], SI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $FF
  BTS         word ptr [EAX], DX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt16(Value or (UInt16(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTS(var Value: UInt32; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         EDX, $FF
  BTS         dword ptr [RCX], EDX
  {$ELSE !Windows}
  AND         ESI, $FF
  BTS         dword ptr [RDI], ESI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EDX, $FF
  BTS         dword ptr [EAX], EDX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt32(Value or (UInt32(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTS(var Value: UInt64; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RDX, $FF
  BTS         qword ptr [RCX], RDX
  {$ELSE !Windows}
  AND         RSI, $FF
  BTS         dword ptr [RDI], RSI
  {$ENDIF !Windows}
 {$ELSE !x64}
  CMP         EDX, 32
  JAE         @TestHigh

  BTS         dword ptr [Value], EDX
  JMP         @SetResult

@TestHigh:
  AND         EDX, $1F
  BTS         dword ptr [EAX + 4], EDX
 {$ENDIF !x64}
@SetResult:
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt64(Value or (UInt64(1) shl Bit));
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and reset (BTR) implementation - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTR(var Value: UInt8; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $7
  MOVZX       RAX, byte ptr [RCX]
  BTR         AX, DX
  MOV         byte ptr [RCX], AL
  {$ELSE !Windows}
  AND         SI, $7
  MOVZX       RAX, byte ptr [RDI]
  BTR         AX, SI
  MOV         byte ptr [RDI], AL
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $7
  MOVZX       ECX, byte ptr [EAX]
  BTR         CX, DX
  MOV         byte ptr [EAX], CL
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt8(Value and not(UInt8(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTR(var Value: UInt16; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $FF
  BTR         word ptr [RCX], DX
  {$ELSE !Windows}
  AND         SI, $FF
  BTR         word ptr [RDI], SI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $FF
  BTR         word ptr [EAX], DX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt16(Value and not(UInt16(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTR(var Value: UInt32; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         EDX, $FF
  BTR         dword ptr [RCX], EDX
  {$ELSE !Windows}
  AND         ESI, $FF
  BTR         dword ptr [RDI], ESI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EDX, $FF
  BTR         dword ptr [EAX], EDX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt32(Value and not(UInt32(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTR(var Value: UInt64; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RDX, $FF
  BTR         qword ptr [RCX], RDX
  {$ELSE !Windows}
  AND         RSI, $FF
  BTR         dword ptr [RDI], RSI
  {$ENDIF !Windows}
 {$ELSE !x64}
  CMP         EDX, 32
  JAE         @TestHigh

  BTR         dword ptr [Value], EDX
  JMP         @SetResult

@TestHigh:
  AND         EDX, $1F
  BTR         dword ptr [EAX + 4], EDX
 {$ENDIF !x64}
@SetResult:
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt64(Value and not(UInt64(1) shl Bit));
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and complement (BTC) implementation  - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and complement (BTC) implementation'}{$ENDIF}
function BTC(var Value: UInt8; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $7
  MOVZX       RAX, byte ptr [RCX]
  BTC         AX, DX
  MOV         byte ptr [RCX], AL
  {$ELSE !Windows}
  AND         SI, $7
  MOVZX       RAX, byte ptr [RDI]
  BTC         AX, SI
  MOV         byte ptr [RDI], AL
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $7
  MOVZX       ECX, byte ptr [EAX]
  BTC         CX, DX
  MOV         byte ptr [EAX], CL
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt8(Value xor (UInt8(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTC(var Value: UInt16; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         DX, $FF
  BTC         word ptr [RCX], DX
  {$ELSE !Windows}
  AND         SI, $FF
  BTC         word ptr [RDI], SI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         DX, $FF
  BTC         word ptr [EAX], DX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt16(Value xor (UInt16(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTC(var Value: UInt32; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         EDX, $FF
  BTC         dword ptr [RCX], EDX
  {$ELSE !Windows}
  AND         ESI, $FF
  BTC         dword ptr [RDI], ESI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EDX, $FF
  BTC         dword ptr [EAX], EDX
 {$ENDIF !x64}
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt32(Value xor (UInt32(1) shl Bit));
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BTC(var Value: UInt64; Bit: UInt8): ByteBool; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RDX, $FF
  BTC         qword ptr [RCX], RDX
  {$ELSE !Windows}
  AND         RSI, $FF
  BTC         dword ptr [RDI], RSI
  {$ENDIF !Windows}
 {$ELSE !x64}
  CMP         EDX, 32
  JAE         @TestHigh

  BTC         dword ptr [Value], EDX
  JMP         @SetResult

@TestHigh:
  AND         EDX, $1F
  BTC         dword ptr [EAX + 4], EDX
 {$ENDIF !x64}
@SetResult:
  SETC        AL
end;
{$ELSE !PurePascal}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt64(Value xor (UInt64(1) shl Bit));
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit test and set to a given value implementation  - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set to a given value implementation'}{$ENDIF}
function BitSetTo(var Value: UInt8; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitSetTo(var Value: UInt16; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitSetTo(var Value: UInt32; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitSetTo(var Value: UInt64; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit scan forward (BSF) implementation - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan forward (BSF) implementation'}{$ENDIF}
function BSF(Value: UInt8): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  XOR         RAX, RAX
  {$IFDEF Windows}
  AND         RCX, $FF
  BSF         AX, CX
  {$ELSE !Windows}
  AND         RDI, $FF
  BSF         AX, DI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FF
  BSF         AX, AX
 {$ENDIF !x64}
  JNZ         @RoutineEnd
  MOV         EAX, -1
@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to 7 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BSF(Value: UInt16): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  XOR         RAX, RAX
  {$IFDEF Windows}
  BSF         AX, CX
  {$ELSE !Windows}
  BSF         AX, DI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FFFF
  BSF         AX, AX
 {$ENDIF !x64}
  JNZ         @RoutineEnd
  MOV         EAX, -1
@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to 15 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BSF(Value: UInt32): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSF         EAX, ECX
  {$ELSE !Windows}
  BSF         EAX, EDI
  {$ENDIF !Windows}
 {$ELSE !x64}
  BSF         EAX, EAX
 {$ENDIF !x64}
  JNZ         @RoutineEnd
  MOV         EAX, -1
@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to 31 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BSF(Value: UInt64): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSF         RAX, RCX
  {$ELSE !Windows}
  BSF         RAX, RDI
  {$ENDIF !Windows}

  JNZ         @RoutineEnd
  MOV         EAX, -1

@RoutineEnd:
 {$ELSE !x64}
  BSF         EAX, dword ptr [Value]
  JNZ         @RoutineEnd

  BSF         EAX, dword ptr [Value + 4]
  JNZ         @Add32

  MOV         EAX, -33

@Add32:
  ADD         EAX, 32

@RoutineEnd:
 {$ENDIF !x64}
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to 63 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit scan reversed (BSR) implementation  - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan reversed (BSR) implementation'}{$ENDIF}
function BSR(Value: UInt8): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  XOR         RAX, RAX
  {$IFDEF Windows}
  AND         RCX, $FF
  BSR         AX, CX
  {$ELSE !Windows}
  AND         RDI, $FF
  BSR         AX, DI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FF
  BSR         AX, AX
 {$ENDIF !x64}
  JNZ         @RoutineEnd
  MOV         EAX, -1
@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 7 downto 0 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BSR(Value: UInt16): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  XOR         RAX, RAX
  {$IFDEF Windows}
  BSR         AX, CX
  {$ELSE !Windows}
  BSR         AX, DI
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FFFF
  BSR         AX, AX
 {$ENDIF !x64}
  JNZ         @RoutineEnd
  MOV         EAX, -1
@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 15 downto 0 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BSR(Value: UInt32): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSR         EAX, ECX
  {$ELSE !Windows}
  BSR         EAX, EDI
  {$ENDIF !Windows}
 {$ELSE !x64}
  BSR         EAX, EAX
 {$ENDIF !x64}
  JNZ         @RoutineEnd
  MOV         EAX, -1
@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 31 downto 0 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BSR(Value: UInt64): Int32; {$IFNDEF PurePascal}register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSR         RAX, RCX
  {$ELSE !Windows}
  BSR         RAX, RDI
  {$ENDIF !Windows}
 {$ELSE !x64}
  BSR         EAX, dword ptr [Value + 4]
  JZ          @ScanLow

  ADD         EAX, 32
  JMP         @RoutineEnd

@ScanLow:
  BSR         EAX, dword ptr [Value]
 {$ENDIF !x64}

  JNZ         @RoutineEnd
  MOV         EAX, -1

@RoutineEnd:
end;
{$ELSE !PurePascal}
var
  I: Integer;
begin
  Result := -1;

  for I := 63 downto 0 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF !PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Population count implementation - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Population count implementation'}{$ENDIF}
{$IFDEF BO_UseLookupTable}
const
  PopCountTable: array[UInt8] of UInt8 = (
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2,
    3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3,
    3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3,
    4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4,
    3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5,
    6, 6, 7, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4,
    4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5,
    6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4, 5,
    3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 3,
    4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6,
    6, 7, 6, 7, 7, 8);
{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_8_Pas(Value: UInt8): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
  Result := PopCountTable[Value];
end;
{$ELSE !BO_UseLookupTable}
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to 8 do
  begin
    if ((Value and 1) <> 0) then
      Inc(Result);

    Value := UInt8(Value shr 1);
  end;
end;
{$ENDIF !BO_UseLookupTable}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_16_Pas(Value: UInt16): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
  Result := PopCountTable[UInt8(Value)] + PopCountTable[UInt8(Value shr 8)];
end;
{$ELSE !BO_UseLookupTable}
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to 16 do
  begin
    if ((Value and 1) <> 0) then
      Inc(Result);

    Value := UInt16(Value shr 1);
  end;
end;
{$ENDIF !BO_UseLookupTable}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_32_Pas(Value: UInt32): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
  Result := PopCountTable[UInt8(Value)] + PopCountTable[UInt8(Value shr 8)] +
            PopCountTable[UInt8(Value shr 16)] + PopCountTable[UInt8(Value shr 24)];
end;
{$ELSE !BO_UseLookupTable}
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to 32 do
  begin
    if ((Value and 1) <> 0) then
      Inc(Result);

    Value := UInt32(Value shr 1);
  end;
end;
{$ENDIF !BO_UseLookupTable}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_64_Pas(Value: UInt64): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
 {$IFDEF 64bit}
  Result := PopCountTable[UInt8(Value)] + PopCountTable[UInt8(Value shr 8)] +
            PopCountTable[UInt8(Value shr 16)] + PopCountTable[UInt8(Value shr 24)] +
            PopCountTable[UInt8(Value shr 32)] + PopCountTable[UInt8(Value shr 40)] +
            PopCountTable[UInt8(Value shr 48)] + PopCountTable[UInt8(Value shr 56)];
 {$ELSE !64bit}
  Result := PopCount(Int64Rec(Value).Lo) + PopCount(Int64Rec(Value).Hi);
 {$ENDIF !64bit}
end;
{$ELSE !BO_UseLookupTable}
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to 64 do
  begin
    if ((Value and 1) <> 0) then
      Inc(Result);

    Value := UInt64(Value shr 1);
  end;
end;
{$ENDIF !BO_UseLookupTable}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFNDEF PurePascal}
function Fce_PopCount_8_Asm(Value: UInt8): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
 {$ELSE !x64}
  AND         EAX, $FF
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $66, $F3, $0F, $B8, $C0   { POPCNT      AX, AX }
 {$ELSE !ASM_MachineCode}
  POPCNT      AX,   AX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_16_Asm(Value: UInt16): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
 {$ELSE !x64}
  AND         EAX, $FFFF
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $66, $F3, $0F, $B8, $C0   { POPCNT      AX, AX }
 {$ELSE !ASM_MachineCode}
  POPCNT      AX, AX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_32_Asm(Value: UInt32): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $B8, $C0        { POPCNT      EAX, EAX }
 {$ELSE !ASM_MachineCode}
  POPCNT      EAX, EAX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_PopCount_64_Asm(Value: UInt64): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  {$IFDEF ASM_MachineCode}
  DB          $F3, $48, $0F, $B8, $C0   { POPCNT      RAX, RAX }
  {$ELSE !ASM_MachineCode}
  POPCNT      RAX, RAX
  {$ENDIF !ASM_MachineCode}
 {$ELSE !x64}
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]
  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $B8, $C0        { POPCNT      EAX, EAX }
  DB          $F3, $0F, $B8, $D2        { POPCNT      EDX, EDX }
  {$ELSE !ASM_MachineCode}
  POPCNT      EAX, EAX
  POPCNT      EDX, EDX
  {$ENDIF !ASM_MachineCode}
  ADD         EAX, EDX
 {$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

var
  Var_PopCount_8: function (Value: UInt8): Int32; register;
  Var_PopCount_16: function (Value: UInt16): Int32; register;
  Var_PopCount_32: function (Value: UInt32): Int32; register;
  Var_PopCount_64: function (Value: UInt64): Int32; register;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function PopCount(Value: UInt8): Int32;
begin
  Result := Var_PopCount_8(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function PopCount(Value: UInt16): Int32;
begin
  Result := Var_PopCount_16(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function PopCount(Value: UInt32): Int32;
begin
  Result := Var_PopCount_32(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function PopCount(Value: UInt64): Int32;
begin
  Result := Var_PopCount_64(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Nibble manipulation implementation  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Nibble manipulation implementation'}{$ENDIF}
function GetHighNibble(Value: UInt8): TNibble;
begin
  Result := (Value shr 4) and $0F;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetLowNibble(Value: UInt8): TNibble;
begin
  Result := Value and $0F;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetHighNibble(Value: UInt8; SetTo: TNibble): UInt8;
begin
  Result := (Value and $0F) or UInt8((SetTo and $0F) shl 4);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetLowNibble(Value: UInt8; SetTo: TNibble): UInt8;
begin
  Result := (Value and $F0) or UInt8(SetTo and $0F);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetHighNibbleValue(var Value: UInt8; SetTo: TNibble);
begin
  Value := SetHighNibble(Value, SetTo);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetLowNibbleValue(var Value: UInt8; SetTo: TNibble);
begin
  Value := SetLowNibble(Value, SetTo);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Get flag state implementation - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Get flag state implementation'}{$ENDIF}
function GetFlagState(Value, FlagBitmask: UInt8; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetFlagState(Value, FlagBitmask: UInt16; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetFlagState(Value, FlagBitmask: UInt32; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetFlagState(Value, FlagBitmask: UInt64; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Set flag implementation - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag implementation'}{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt8): UInt8;
begin
  Result := Value or FlagBitmask;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlag(Value,FlagBitmask: UInt16): UInt16;
begin
  Result := Value or FlagBitmask;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlag(Value,FlagBitmask: UInt32): UInt32;
begin
  Result := Value or FlagBitmask;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlag(Value,FlagBitmask: UInt64): UInt64;
begin
  Result := Value or FlagBitmask;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagValue(var Value: UInt8; FlagBitmask: UInt8);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagValue(var Value: UInt16; FlagBitmask: UInt16);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagValue(var Value: UInt32; FlagBitmask: UInt32);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagValue(var Value: UInt64; FlagBitmask: UInt64);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
var
  TempBitmask: UInt8;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := SetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
var
  TempBitmask: UInt16;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := SetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
var
  TempBitmask: UInt32;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := SetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;
var
  TempBitmask: UInt64;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := SetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags(Value: UInt8; Flags: array of UInt8): UInt8;
begin
  Result := SetFlags_8(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags(Value: UInt16; Flags: array of UInt16): UInt16;
begin
  Result := SetFlags_16(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags(Value: UInt32; Flags: array of UInt32): UInt32;
begin
  Result := SetFlags_32(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlags(Value: UInt64; Flags: array of UInt64): UInt64;
begin
  Result := SetFlags_64(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
begin
  Value := SetFlags_8(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
begin
  Value := SetFlags_16(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
begin
  Value := SetFlags_32(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);
begin
  Value := SetFlags_64(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue(var Value: UInt8; Flags: array of UInt8);
begin
  SetFlagsValue_8(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue(var Value: UInt16; Flags: array of UInt16);
begin
  SetFlagsValue_16(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue(var Value: UInt32; Flags: array of UInt32);
begin
  SetFlagsValue_32(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagsValue(var Value: UInt64; Flags: array of UInt64);
begin
  SetFlagsValue_64(Value, Flags);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Reset flag implementation - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Reset flag implementation'}{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt8): UInt8;
begin
  Result := ((Value) and (not FlagBitmask));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlag(Value, FlagBitmask: UInt16): UInt16;
begin
  Result := ((Value) and (not FlagBitmask));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlag(Value, FlagBitmask: UInt32): UInt32;
begin
  Result := ((Value) and (not FlagBitmask));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlag(Value, FlagBitmask: UInt64): UInt64;
begin
  Result := ((Value) and (not FlagBitmask));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagValue(var Value: UInt8; FlagBitmask: UInt8);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagValue(var Value: UInt16; FlagBitmask: UInt16);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagValue(var Value: UInt32; FlagBitmask: UInt32);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagValue(var Value: UInt64; FlagBitmask: UInt64);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
var
  TempBitmask: UInt8;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[I];

  Result := ResetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
var
  TempBitmask: UInt16;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[I];

  Result := ResetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
var
  TempBitmask: UInt32;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[I];

  Result := ResetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;
var
  TempBitmask: UInt64;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[I];

  Result := ResetFlag(Value, TempBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags(Value: UInt8; Flags: array of UInt8): UInt8;
begin
  Result := ResetFlags_8(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags(Value: UInt16; Flags: array of UInt16): UInt16;
begin
  Result := ResetFlags_16(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags(Value: UInt32; Flags: array of UInt32): UInt32;
begin
  Result := ResetFlags_32(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ResetFlags(Value: UInt64; Flags: array of UInt64): UInt64;
begin
  Result := ResetFlags_64(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
begin
  Value := ResetFlags_8(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
begin
  Value := ResetFlags_16(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
begin
  Value := ResetFlags_32(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);
begin
  Value := ResetFlags_64(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue(var Value: UInt8; Flags: array of UInt8);
begin
  ResetFlagsValue_8(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue(var Value: UInt16; Flags: array of UInt16);
begin
  ResetFlagsValue_16(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue(var Value: UInt32; Flags: array of UInt32);
begin
  ResetFlagsValue_32(Value, Flags);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ResetFlagsValue(var Value: UInt64; Flags: array of UInt64);
begin
  ResetFlagsValue_64(Value, Flags);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Set flag state implementation - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag state implementation'}{$ENDIF}
function SetFlagState(Value, FlagBitmask: UInt8; NewState: Boolean): UInt8;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlagState(Value, FlagBitmask: UInt16; NewState: Boolean): UInt16;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlagState(Value, FlagBitmask: UInt32; NewState: Boolean): UInt32;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetFlagState(Value, FlagBitmask: UInt64; NewState: Boolean): UInt64;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagStateValue(var Value: UInt8; FlagBitmask: UInt8; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagStateValue(var Value: UInt16; FlagBitmask: UInt16; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagStateValue(var Value: UInt32; FlagBitmask: UInt32; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetFlagStateValue(var Value: UInt64; FlagBitmask: UInt64; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Get bits implementation - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Get bits implementation'}{$ENDIF}
function GetBits(Value: UInt8; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt8;
begin
  Result := Value and UInt8(($FF shl (FromBit and 7)) and ($FF shr (7 - (ToBit and 7))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 7);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetBits(Value: UInt16; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt16;
begin
  Result := Value and UInt16(($FFFF shl (FromBit and 15)) and ($FFFF shr (15 - (ToBit and 15))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 15);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetBits(Value: UInt32; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt32;
begin
  Result := Value and UInt32(($FFFFFFFF shl (FromBit and 31)) and ($FFFFFFFF shr (31 - (ToBit and 31))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 31);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function GetBits(Value: UInt64; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt64;
begin
  Result := Value and UInt64((UInt64($FFFFFFFFFFFFFFFF) shl (FromBit and 63)) and (UInt64($FFFFFFFFFFFFFFFF) shr (63 - (ToBit and 63))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 63);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Set bits implementation - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Set bits implementation'}{$ENDIF}
function SetBits(Value, NewBits: UInt8; FromBit, ToBit: Integer): UInt8;
var
  Mask: UInt8;
begin
  Mask := UInt8(($FF shl (FromBit and 7)) and ($FF shr (7 - (ToBit and 7))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetBits(Value, NewBits: UInt16; FromBit, ToBit: Integer): UInt16;
var
  Mask: UInt16;
begin
  Mask := UInt16(($FFFF shl (FromBit and 15)) and ($FFFF shr (15 - (ToBit and 15))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetBits(Value, NewBits: UInt32; FromBit, ToBit: Integer): UInt32;
var
  Mask: UInt32;
begin
  Mask := UInt32(($FFFFFFFF shl (FromBit and 31)) and ($FFFFFFFF shr (31 - (ToBit and 31))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SetBits(Value, NewBits: UInt64; FromBit, ToBit: Integer): UInt64;
var
  Mask: UInt64;
begin
  Mask := UInt64((UInt64($FFFFFFFFFFFFFFFF) shl (FromBit and 63)) and (UInt64($FFFFFFFFFFFFFFFF) shr (63 - (ToBit and 63))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetBitsValue(var Value: UInt8; NewBits: UInt8; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetBitsValue(var Value: UInt16; NewBits: UInt16; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetBitsValue(var Value: UInt32; NewBits: UInt32; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure SetBitsValue(var Value: UInt64; NewBits: UInt64; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Reverse bits implementation - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Reverse bits implementation'}{$ENDIF}
const
  RevBitsTable: array[UInt8] of UInt8 = (
    $00, $80, $40, $C0, $20, $A0, $60, $E0, $10, $90, $50, $D0, $30, $B0, $70,
    $F0, $08, $88, $48, $C8, $28, $A8, $68, $E8, $18, $98, $58, $D8, $38, $B8,
    $78, $F8, $04, $84, $44, $C4, $24, $A4, $64, $E4, $14, $94, $54, $D4, $34,
    $B4, $74, $F4, $0C, $8C, $4C, $CC, $2C, $AC, $6C, $EC, $1C, $9C, $5C, $DC,
    $3C, $BC, $7C, $FC, $02, $82, $42, $C2, $22, $A2, $62, $E2, $12, $92, $52,
    $D2, $32, $B2, $72, $F2, $0A, $8A, $4A, $CA, $2A, $AA, $6A, $EA, $1A, $9A,
    $5A, $DA, $3A, $BA, $7A, $FA, $06, $86, $46, $C6, $26, $A6, $66, $E6, $16,
    $96, $56, $D6, $36, $B6, $76, $F6, $0E, $8E, $4E, $CE, $2E, $AE, $6E, $EE,
    $1E, $9E, $5E, $DE, $3E, $BE, $7E, $FE, $01, $81, $41, $C1, $21, $A1, $61,
    $E1, $11, $91, $51, $D1, $31, $B1, $71, $F1, $09, $89, $49, $C9, $29, $A9,
    $69, $E9, $19, $99, $59, $D9, $39, $B9, $79, $F9, $05, $85, $45, $C5, $25,
    $A5, $65, $E5, $15, $95, $55, $D5, $35, $B5, $75, $F5, $0D, $8D, $4D, $CD,
    $2D, $AD, $6D, $ED, $1D, $9D, $5D, $DD, $3D, $BD, $7D, $FD, $03, $83, $43,
    $C3, $23, $A3, $63, $E3, $13, $93, $53, $D3, $33, $B3, $73, $F3, $0B, $8B,
    $4B, $CB, $2B, $AB, $6B, $EB, $1B, $9B, $5B, $DB, $3B, $BB, $7B, $FB, $07,
    $87, $47, $C7, $27, $A7, $67, $E7, $17, $97, $57, $D7, $37, $B7, $77, $F7,
    $0F, $8F, $4F, $CF, $2F, $AF, $6F, $EF, $1F, $9F, $5F, $DF, $3F, $BF, $7F,
    $FF);

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ReverseBits(Value: UInt8): UInt8;
begin
  Result := UInt8(RevBitsTable[UInt8(Value)]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ReverseBits(Value: UInt16): UInt16;
begin
  Result := UInt16((UInt16(RevBitsTable[UInt8(Value)]) shl 8) or
                    UInt16(RevBitsTable[UInt8(Value shr 8)]));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ReverseBits(Value: UInt32): UInt32;
begin
Result := UInt32((UInt32(RevBitsTable[UInt8(Value)]) shl 24) or
                 (UInt32(RevBitsTable[UInt8(Value shr 8)]) shl 16) or
                 (UInt32(RevBitsTable[UInt8(Value shr 16)]) shl 8) or
                  UInt32(RevBitsTable[UInt8(Value shr 24)]));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ReverseBits(Value: UInt64): UInt64;
begin
  Int64Rec(Result).Hi := ReverseBits(Int64Rec(Value).Lo);
  Int64Rec(Result).Lo := ReverseBits(Int64Rec(Value).Hi);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ReverseBitsValue(var Value: UInt8);
begin
  Value := ReverseBits(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ReverseBitsValue(var Value: UInt16);
begin
  Value := ReverseBits(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ReverseBitsValue(var Value: UInt32);
begin
  Value := ReverseBits(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure ReverseBitsValue(var Value: UInt64);
begin
  Value := ReverseBits(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Leading zero count implementation - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Leading zero count implementation'}{$ENDIF}
function Fce_LZCount_8_Pas(Value: UInt8): Int32; register;
var
  I: Integer;
begin
  Result := 8;

  for I := 0 to 7 do
    if ((Value and (UInt8($80) shr I)) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_LZCount_16_Pas(Value: UInt16): Int32; register;
var
  I: Integer;
begin
  Result := 16;

  for I := 0 to 15 do
    if ((Value and (UInt16($8000) shr I)) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_LZCount_32_Pas(Value: UInt32): Int32; register;
var
  I: Integer;
begin
  Result := 32;

  for I := 0 to 31 do
    if ((Value and (UInt32($80000000) shr I)) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_LZCount_64_Pas(Value: UInt64): Int32; register;
var
  I: Integer;
begin
  Result := 64;

  for I := 0 to 63 do
    if ((Value and (UInt64($8000000000000000) shr I)) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFNDEF PurePascal}
function Fce_LZCount_8_Asm(Value: UInt8): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
 {$ELSE !x64}
  AND         EAX, $FF
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $66, $F3, $0F, $BD, $C0   { LZCNT       AX, AX }
 {$ELSE !ASM_MachineCode}
  LZCNT       AX, AX
  SUB         AX, 8
 {$ENDIF !ASM_MachineCOde}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_LZCount_16_Asm(Value: UInt16): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
 {$ELSE !x64}
  AND         EAX, $FFFF
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $66, $F3, $0F, $BD, $C0   { LZCNT       AX, AX }
 {$ELSE !ASM_MachineCode}
  LZCNT       AX, AX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_LZCount_32_Asm(Value: UInt32): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $BD, $C0       { LZCNT        EAX, EAX }
 {$ELSE !ASM_MachineCode}
  LZCNT       EAX, EAX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_LZCount_64_Asm(Value: UInt64): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  {$IFDEF ASM_MachineCode}
  DB          $F3, $48, $0F, $BD, $C0   { LZCNT       RAX, RAX }
  {$ELSE !ASM_MachineCode}
  LZCNT       RAX, RAX
  {$ENDIF !ASM_MachineCode}
 {$ELSE !x64}
  MOV         EAX, dword ptr [Value + 4]
  TEST        EAX, EAX
  JZ          @ScanLow

  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $BD, $C0        { LZCNT       EAX, EAX }
  {$ELSE !ASM_MachineCode}
  LZCNT       EAX, EAX
  {$ENDIF !ASM_MachineCode}
  JMP         @RoutineEnd

@ScanLow:
  MOV         EAX, dword ptr [Value]
  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $BD, $C0        { LZCNT       EAX, EAX }
  {$ELSE !ASM_MachineCode}
  LZCNT       EAX, EAX
  {$ENDIF !ASM_MachineCode}
  ADD         EAX, 32

  @RoutineEnd:
 {$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

var
  Var_LZCount_8: function (Value: UInt8): Int32; register;
  Var_LZCount_16: function (Value: UInt16): Int32; register;
  Var_LZCount_32: function (Value: UInt32): Int32; register;
  Var_LZCount_64: Function (Value: UInt64): Int32; register;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function LZCount(Value: UInt8): Int32;
begin
  Result := Var_LZCount_8(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function LZCount(Value: UInt16): Int32;
begin
  Result := Var_LZCount_16(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function LZCount(Value: UInt32): Int32;
begin
  Result := Var_LZCount_32(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function LZCount(Value: UInt64): Int32;
begin
  Result := Var_LZCount_64(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Trailing zero count implementation  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Trailing zero count implementation'}{$ENDIF}
function Fce_TZCount_8_Pas(Value: UInt8): Int32; register;
var
  I: Integer;
begin
  Result := 8;

  for I := 0 to 7 do
    if (((Value shr I) and 1) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_TZCount_16_Pas(Value: UInt16): Int32; register;
var
  I: Integer;
begin
  Result := 16;

  for I := 0 to 15 do
  if (((Value shr I) and 1) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_TZCount_32_Pas(Value: UInt32): Int32; register;
var
  I: Integer;
begin
  Result := 32;

  for I := 0 to 31 do
    if (((Value shr I) and 1) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_TZCount_64_Pas(Value: UInt64): Int32; register;
var
  I: Integer;
begin
  Result := 64;

  for I := 0 to 63 do
    if (((Value shr I) and 1) <> 0) then
    begin
      Result := I;
      Break{for I};
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFNDEF PurePascal}
function Fce_TZCount_8_Asm(Value: UInt8): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
 {$ELSE !x64}
  AND         EAX, $FF
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $66, $F3, $0F, $BC, $C0   { TZCNT       AX, AX }
 {$ELSE !ASM_MachineCode}
  MOV         AH, $FF
  TZCNT       AX, AX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_TZCount_16_Asm(Value: UInt16): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
 {$ELSE !x64}
  AND         EAX, $FFFF
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $66, $F3, $0F, $BC, $C0   { TZCNT       AX, AX }
 {$ELSE !ASM_MachineCode}
  TZCNT       AX, AX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_TZCount_32_Asm(Value: UInt32): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $BC, $C0        { TZCNT       EAX, EAX }
 {$ELSE !ASM_MachineCode}
  TZCNT       EAX, EAX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_TZCount_64_Asm(Value: UInt64): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  {$IFDEF ASM_MachineCode}
  DB          $F3, $48, $0F, $BC, $C0   { TZCNT       RAX, RAX }
  {$ELSE !ASM_MachineCode}
  TZCNT       RAX, RAX
  {$ENDIF !ASM_MachineCode}
 {$ELSE !x64}
  MOV         EAX, dword ptr [Value]
  TEST        EAX, EAX
  JZ          @ScanHigh

  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $BC, $C0        { TZCNT       EAX, EAX }
  {$ELSE !ASM_MachineCode}
  TZCNT       EAX, EAX
  {$ENDIF !ASM_MachineCode}
  JMP         @RoutineEnd

@ScanHigh:
  MOV         EAX, dword ptr [Value + 4]
  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $BC, $C0        { TZCNT       EAX, EAX }
  {$ELSE !ASM_MachineCode}
  TZCNT       EAX, EAX
  {$ENDIF !ASM_MachineCode}
  ADD         EAX, 32

@RoutineEnd:
 {$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

var
  Var_TZCount_8: function (Value: UInt8): Int32; register;
  Var_TZCount_16: function (Value: UInt16): Int32; register;
  Var_TZCount_32: function (Value: UInt32): Int32; register;
  Var_TZCount_64: function (Value: UInt64): Int32; register;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TZCount(Value: UInt8): Int32;
begin
  Result := Var_TZCount_8(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TZCount(Value: UInt16): Int32;
begin
  Result := Var_TZCount_16(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TZCount(Value: UInt32): Int32;
begin
  Result := Var_TZCount_32(Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TZCount(Value: UInt64): Int32;
begin
  Result := Var_TZCount_64(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Extract bits implementation - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Extract bits implementation'}{$ENDIF}
{$IFDEF OverflowChecks}{$Q-}{$ENDIF}
function Fce_ExtractBits_8_Pas(Value: UInt8; Start, Length: UInt8): UInt8; register;
begin
  if (Start <= 7) then
  begin
    if (Length <= 7) then
      Result := UInt8(Value shr Start) and UInt8(Int8(UInt8(1) shl Length) - 1)
    else
      Result := UInt8(Value shr Start) and UInt8(-1);
  end else
    Result := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ExtractBits_16_Pas(Value: UInt16; Start, Length: UInt8): UInt16; register;
begin
  if (Start <= 15) then
  begin
    if (Length <= 15) then
      Result := UInt16(Value shr Start) and UInt16(Int16(UInt16(1) shl Length) - 1)
    else
      Result := UInt16(Value shr Start) and UInt16(-1);
  end else
    Result := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ExtractBits_32_Pas(Value: UInt32; Start, Length: UInt8): UInt32; register;
begin
  if (Start <= 31) then
  begin
    if (Length <= 31) then
      Result := UInt32(Value shr Start) and UInt32(Int32(UInt32(1) shl Length) - 1)
    else
      Result := UInt32(Value shr Start) and UInt32(-1);
  end else
    Result := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ExtractBits_64_Pas(Value: UInt64; Start, Length: UInt8): UInt64; register;
begin
  if (Start <= 63) then
  begin
    if (Length <= 63) then
      Result := UInt64(Value shr Start) and UInt64(Int64(UInt64(1) shl Length) - 1)
    else
      Result := UInt64(Value shr Start) and UInt64(-1);
  end else
    Result := 0;
end;
{$IFDEF OverflowChecks}{$Q+}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFNDEF PurePascal}
function Fce_ExtractBits_8_Asm(Value: UInt8; Start, Length: UInt8): UInt8; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
  {$IFDEF Windows}
  SHL         R8, 8
  AND         RDX, $FF
  OR          RDX, R8
  {$ELSE !Windows}
  SHL         RDX, 8
  MOV         DL, SIL
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FF
  MOV         DH, CL
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $68, $F7, $C0   { BEXTR       EAX, EAX, EDX }
 {$ELSE !ASM_MachineCode}
  BEXTR       EAX, EAX, EDX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ExtractBits_16_Asm(Value: UInt16; Start, Length: UInt8): UInt16; register; assembler;
asm
 {$IFDEF x64}
  MOVZX       RAX, Value
  {$IFDEF Windows}
  SHL         R8, 8
  AND         RDX, $FF
  OR          RDX, R8
  {$ELSE !Windows}
  SHL         RDX, 8
  MOV         DL, SIL
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FFFF
  MOV         DH, CL
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $68, $F7, $C0   { BEXTR       EAX, EAX, EDX }
 {$ELSE !ASM_MachineCode}
  BEXTR       EAX, EAX, EDX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ExtractBits_32_Asm(Value: UInt32; Start, Length: UInt8): UInt32; register; assembler;
asm
 {$IFDEF x64}
  MOV         EAX, Value
  {$IFDEF Windows}
  SHL         R8, 8
  AND         RDX, $FF
  OR          RDX, R8
  {$ELSE !Windows}
  SHL         RDX, 8
  MOV         DL, SIL
  {$ENDIF !Windows}
 {$ELSE !x64}
  MOV         DH, CL
 {$ENDIF !x64}
 {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $68, $F7, $C0   { BEXTR       EAX, EAX, EDX }
 {$ELSE !ASM_MachineCode}
  BEXTR       EAX, EAX, EDX
 {$ENDIF !ASM_MachineCode}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ExtractBits_64_Asm(Value: UInt64; Start, Length: UInt8): UInt64; register; assembler;
asm
 {$IFDEF x64}
  MOV         RAX, Value
  {$IFDEF Windows}
  SHL         R8, 8
  AND         RDX, $FF
  OR          RDX, R8
  {$ELSE !Windows}
  SHL         RDX, 8
  MOV         DL, SIL
  {$ENDIF !Windows}
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $E8, $F7, $C0   { BEXTR       RAX, RAX, RDX }
  {$ELSE !ASM_MachineCode}
  BEXTR       RAX, RAX, RDX
  {$ENDIF !ASM_MachineCOde}
 {$ELSE !x64}
  MOV         CL, AL
  MOV         CH, DL

  AND         EAX, $FF
  AND         EDX, $FF
  ADD         EAX, EDX

  XOR         EDX, EDX

  CMP         CL, 31
  JA          @AllHigh

  CMP         EAX, 32
  JBE         @AllLow

  { Extraction is done across low and high dwords boundary. }
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]

  { Extract from low dword. }
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $70, $F7, $C0   { BEXTR       EAX, EAX, ECX }
  {$ELSE !ASM_MachineCode}
  BEXTR       EAX, EAX, ECX
  {$ENDIF !ASM_MachineCode}

  { Extract form high dword. }
  PUSH        ECX
  ADD         CH, CL
  SUB         CH, 32
  XOR         CL, CL

  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $70, $F7, $D2   { BEXTR       EDX, EDX, ECX }
  {$ELSE !ASM_MachineCode}
  BEXTR       EDX, EDX, ECX
  {$ENDIF !ASM_MachineCode}

  { Combine results. }
  POP         ECX
  PUSH        EBX

  XOR         EBX, EBX
  SHRD        EBX, EDX, CL
  SHR         EDX, CL
  OR          EAX, EBX

  POP         EBX
  JMP         @RoutineEnd

  { Extraction is done only from low dword. }
@AllLow:

  MOV         EAX, dword ptr [Value]
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $70, $F7, $C0   { BEXTR       EAX, EAX, ECX }
  {$ELSE !ASM_MachineCode}
  BEXTR       EAX, EAX, ECX
  {$ENDIF !ASM_MachineCode}
  JMP         @RoutineEnd

  { Extraction is done only from high dword. }
@AllHigh:

  SUB         CL, 32
  MOV         EAX, dword ptr [Value + 4]
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $70, $F7, $C0   { BEXTR       EAX, EAX, ECX }
  {$ELSE !ASM_MachineCode}
  BEXTR       EAX, EAX, ECX
  {$ENDIF !ASM_MachineCode}

@RoutineEnd:
{$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

var
  Var_ExtractBits_8: function (Value: UInt8; Start, Length: UInt8): UInt8; register;
  Var_ExtractBits_16: function (Value: UInt16; Start, Length: UInt8): UInt16; register;
  Var_ExtractBits_32: function (Value: UInt32; Start, Length: UInt8): UInt32; register;
  Var_ExtractBits_64: function (Value: UInt64; Start, Length: UInt8): UInt64; register;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ExtractBits(Value: UInt8; Start, Length: UInt8): UInt8;
begin
  Result := Var_ExtractBits_8(Value, Start, Length);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ExtractBits(Value: UInt16; Start, Length: UInt8): UInt16;
begin
  Result := Var_ExtractBits_16(Value, Start, Length);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ExtractBits(Value: UInt32; Start, Length: UInt8): UInt32;
begin
  Result := Var_ExtractBits_32(Value, Start, Length);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ExtractBits(Value: UInt64; Start, Length: UInt8): UInt64;
begin
  Result := Var_ExtractBits_64(Value, Start, Length);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Parallel bits extract implementation  - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits extract implementation'}{$ENDIF}
function Fce_ParallelBitsExtract_8_Pas(Value, Mask: UInt8): UInt8; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 7 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt8(Result shl 1) or UInt8((Value shr I) and 1);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsExtract_16_Pas(Value, Mask: UInt16): UInt16; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 15 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt16(Result shl 1) or UInt16((Value shr I) and 1);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsExtract_32_Pas(Value, Mask: UInt32): UInt32; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 31 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt32(Result shl 1) or UInt32((Value shr I) and 1);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsExtract_64_Pas(Value, Mask: UInt64): UInt64; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 63 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt64(Result shl 1) or UInt64((Value shr I) and 1);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFNDEF PurePascal}
function Fce_ParallelBitsExtract_8_Asm(Value, Mask: UInt8): UInt8; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RCX, $FF
  AND         RDX, $FF

   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $72, $F5, $C2     { PEXT        EAX, ECX, EDX }
   {$ELSE !ASM_MachineCode}
  PEXT        EAX, ECX, EDX
   {$ENDIF !ASM_MachineCode}

  {$ELSE !Windows}
  AND         RDI, $FF
  AND         RSI, $FF

   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $42, $F5, $C6     { PEXT        EAX, EDI, ESI }
   {$ELSE !ASM_MachineCode}
  PEXT        EAX, EDI, ESI
   {$ENDIF !ASM_MachineCode}

  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FF
  AND         EDX, $FF

  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7A, $F5, $C2     { PEXT        EAX, EAX, EDX }
  {$ELSE !ASM_MachineCode}
  PEXT        EAX, EAX, EDX
  {$ENDIF !ASM_MachineCode}

 {$ENDIF !x64}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsExtract_16_Asm(Value, Mask: UInt16): UInt16; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RCX, $FFFF
  AND         RDX, $FFFF

   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $72, $F5, $C2     { PEXT        EAX, ECX, EDX }
   {$ELSE !ASM_MachineCode}
  PEXT        EAX, ECX, EDX
   {$ENDIF !ASM_MachineCode}

  {$ELSE !Windows}
  AND         RDI, $FFFF
  AND         RSI, $FFFF

   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $42, $F5, $C6     { PEXT        EAX, EDI, ESI }
   {$ELSE !ASM_MachineCode}
  PEXT        EAX, EDI, ESI
   {$ENDIF !ASM_MachineCode}

  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FFFF
  AND         EDX, $FFFF

  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7A, $F5, $C2     { PEXT        EAX, EAX, EDX }
  {$ELSE !ASM_MachineCode}
  PEXT        EAX, EAX, EDX
  {$ENDIF !ASM_MachineCode}

 {$ENDIF !x64}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsExtract_32_Asm(Value, Mask: UInt32): UInt32; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $72, $F5, $C2     { PEXT        EAX, ECX, EDX }
   {$ELSE !ASM_MachineCode}
  PEXT        EAX, ECX, EDX
   {$ENDIF !ASM_MachineCode}
  {$ELSE !Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $42, $F5, $C6     { PEXT        EAX, EDI, ESI }
   {$ELSE !ASM_MachineCode}
  PEXT        EAX, EDI, ESI
   {$ENDIF !ASM_MachineCode}
  {$ENDIF !Windows}
 {$ELSE !x64}
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7A, $F5, $C2     { PEXT        EAX, EAX, EDX }
  {$ELSE !ASM_MachineCode}
  PEXT        EAX, EAX, EDX
  {$ENDIF !ASM_MachineCode}
 {$ENDIF !x64}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsExtract_64_Asm(Value, Mask: UInt64): UInt64; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $F2, $F5, $C2       { PEXT        RAX, RCX, RDX }
   {$ELSE !ASM_MachineCode}
  PEXT        RAX, RCX, RDX
   {$ENDIF !ASM_MachineCode}
  {$ELSE !Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $C2, $F5, $C6       { PEXT        RAX, RDI, RSI }
   {$ELSE !ASM_MachineCode}
  PEXT        RAX, RDI, RSI
   {$ENDIF !ASM_MachineCode}
  {$ENDIF !Windows}
 {$ELSE !x64}
  MOV         EAX, dword ptr [Value]
  MOV         EDX, dword ptr [Value + 4]
  MOV         ECX, dword ptr [Mask]

  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7A, $F5, $C1       { PEXT        EAX, EAX, ECX }
  DB          $C4, $E2, $6A, $F5, $55, $0C // PEXT        EDX, EDX, dword ptr [EBP + 12 {Mask + 4}]
  {$ELSE !ASM_MachineCode}
  PEXT        EAX, EAX, ECX
  PEXT        EDX, EDX, dword ptr [EBX + 12 {Mask + 4}]
  {$ENDIF !ASM_MachineCode}

  { Combine results. }
  TEST        ECX, ECX
  JNZ         @Shift

  { Low dword is empty. }
  MOV         EAX,  EDX
  XOR         EDX,  EDX
  JMP         @RoutineEnd

@Shift:
  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $B8, $C9            { POPCNT      ECX,  ECX }
  {$ELSE !ASM_MachineCode}
  POPCNT      ECX, ECX
  {$ENDIF !ASM_MachineCode}

  PUSH        EBX
  XOR         EBX, EBX

  NEG         CL
  ADD         CL, 32

  SHRD        EBX, EDX, CL
  SHR         EDX, CL
  OR          EAX, EBX

  POP         EBX

@RoutineEnd:
 {$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

var
  Var_ParallelBitsExtract_8: function (Value, Mask: UInt8): UInt8; register;
  Var_ParallelBitsExtract_16: function (Value, Mask: UInt16): UInt16; register;
  Var_ParallelBitsExtract_32: function (Value, Mask: UInt32): UInt32; register;
  Var_ParallelBitsExtract_64: function (Value, Mask: UInt64): UInt64; register;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsExtract(Value, Mask: UInt8): UInt8;
begin
  Result := Var_ParallelBitsExtract_8(Value, Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsExtract(Value, Mask: UInt16): UInt16;
begin
  Result := Var_ParallelBitsExtract_16(Value, Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsExtract(Value, Mask: UInt32): UInt32;
begin
  Result := Var_ParallelBitsExtract_32(Value, Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsExtract(Value, Mask: UInt64): UInt64;
begin
  Result := Var_ParallelBitsExtract_64(Value, Mask);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Parallel bits deposit implementation  - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits deposit implementation'}{$ENDIF}
function Fce_ParallelBitsDeposit_8_Pas(Value, Mask: UInt8): UInt8; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to 7 do
  begin
    if (((Mask shr I) and 1) <> 0) then
    begin
      Result := Result or UInt8(UInt8(Value and 1) shl I);
      Value := Value shr 1;
    end;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsDeposit_16_Pas(Value, Mask: UInt16): UInt16; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to 15 do
  begin
    if (((Mask shr I) and 1) <> 0) then
    begin
      Result := Result or UInt16(UInt16(Value and 1) shl I);
      Value := Value shr 1;
    end;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsDeposit_32_Pas(Value, Mask: UInt32): UInt32; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to 31 do
  begin
    if (((Mask shr I) and 1) <> 0) then
    begin
      Result := Result or UInt32(UInt32(Value and 1) shl I);
      Value := Value shr 1;
    end;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsDeposit_64_Pas(Value, Mask: UInt64): UInt64; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to 63 do
  begin
    if (((Mask shr I) and 1) <> 0) then
    begin
      Result := Result or UInt64(UInt64(Value and 1) shl I);
      Value := Value shr 1;
    end;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFNDEF PurePascal}
function Fce_ParallelBitsDeposit_8_Asm(Value, Mask: UInt8): UInt8; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RCX, $FF
  AND         RDX, $FF
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $73, $F5, $C2     { PDEP        EAX, ECX, EDX }
   {$ELSE !ASM_MachineCode}
  PDEP        EAX, ECX, EDX
   {$ENDIF !ASM_MachineCode}
  {$ELSE !Windows}
  AND         RDI, $FF
  AND         RSI, $FF
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $43, $F5, $C6     { PDEP        EAX, EDI, ESI }
   {$ELSE !ASM_MachineCode}
  PDEP        EAX, EDI, ESI
   {$ENDIF !ASM_MachineCode}
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FF
  AND         EDX, $FF
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7B, $F5, $C2     { PDEP        EAX, EAX, EDX }
  {$ELSE !ASM_MachineCode}
  PDEP        EAX, EAX, EDX
  {$ENDIF !ASM_MachineCode}
 {$ENDIF !x64}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsDeposit_16_Asm(Value, Mask: UInt16): UInt16; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND         RCX, $FFFF
  AND         RDX, $FFFF
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $73, $F5, $C2     { PDEP        EAX, ECX, EDX }
   {$ELSE !ASM_MachineCode}
  PDEP        EAX, ECX, EDX
   {$ENDIF !ASM_MachineCode}
  {$ELSE !Windows}
  AND         RDI, $FFFF
  AND         RSI, $FFFF
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $43, $F5, $C6     { PDEP        EAX, EDI, ESI }
   {$ELSE !ASM_MachineCode}
  PDEP        EAX, EDI, ESI
   {$ENDIF !ASM_MachineCode}
  {$ENDIF !Windows}
 {$ELSE !x64}
  AND         EAX, $FFFF
  AND         EDX, $FFFF
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7B, $F5, $C2     { PDEP        EAX, EAX, EDX }
  {$ELSE !ASM_MachineCode}
  PDEP        EAX, EAX, EDX
  {$ENDIF !ASM_MachineCode}
 {$ENDIF !x64}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsDeposit_32_Asm(Value, Mask: UInt32): UInt32; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $73, $F5, $C2     { PDEP        EAX, ECX, EDX }
   {$ELSE !ASM_MachineCode}
  PDEP        EAX, ECX, EDX
   {$ENDIF !ASM_MachineCode}
  {$ELSE !Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $43, $F5, $C6     { PDEP        EAX, EDI, ESI }
   {$ELSE !ASM_MachineCode}
  PDEP        EAX, EDI, ESI
   {$ENDIF !ASM_MachineCode}
  {$ENDIF !Windows}
 {$ELSE !x64}
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $7B, $F5, $C2     { PDEP        EAX, EAX, EDX }
  {$ELSE !ASM_MachineCode}
  PDEP        EAX, EAX, EDX
  {$ENDIF !ASM_MachineCode}
 {$ENDIF !x64}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Fce_ParallelBitsDeposit_64_Asm(Value, Mask: UInt64): UInt64; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $F3, $F5, $C2     { PDEP        RAX, RCX, RDX }
   {$ELSE !ASM_MachineCode}
  PDEP        RAX, RCX, RDX
   {$ENDIF !ASM_MachineCode}
  {$ELSE !Windows}
   {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $C3, $F5, $C6     { PDEP        RAX, RDI, RSI }
   {$ELSE !ASM_MachineCode}
  PDEP        RAX, RDI, RSI
   {$ENDIF !ASM_MachineCode}
  {$ENDIF !Windows}
 {$ELSE !x64}
  XOR         EAX, EAX
  MOV         EDX, dword ptr [Value]
  MOV         ECX, dword ptr [Mask]

  TEST        ECX, ECX
  JZ          @DepositHigh

  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $6B, $F5, $C1     { PDEP        EAX, EDX, ECX }
  {$ELSE !ASM_MachineCode}
  PDEP        EAX, EDX, ECX
  {$ENDIF !ASM_MachineCode}

  {$IFDEF ASM_MachineCode}
  DB          $F3, $0F, $B8, $C9          { POPCNT      ECX, ECX }
  {$ELSE !ASM_MachineCode}
  POPCNT      ECX, ECX
  {$ENDIF !ASM_MachineCode}

  CMP         ECX, 32
  CMOVAE      EDX, dword ptr [Value + 4]
  JAE         @DepositHigh

@Shift:
  PUSH        EBX

  MOV         EBX, dword ptr [Value + 4]
  SHRD        EDX, EBX, CL

  POP         EBX

@DepositHigh:
  {$IFDEF ASM_MachineCode}
  DB          $C4, $E2, $6B, $F5, $55, $0C//PDEP        EDX, EDX, dword ptr [EBP + 12 {Mask + 4}]
  {$ELSE !ASM_MachineCode}
  PDEP        EDX, EDX, dword ptr [EBP + 12 {Mask + 4}]
  {$ENDIF !ASM_MachineCode}
 {$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

var
  Var_ParallelBitsDeposit_8: function (Value, Mask: UInt8): UInt8; register;
  Var_ParallelBitsDeposit_16: function (Value, Mask: UInt16): UInt16; register;
  Var_ParallelBitsDeposit_32: function (Value, Mask: UInt32): UInt32; register;
  Var_ParallelBitsDeposit_64: function (Value, Mask: UInt64): UInt64; register;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsDeposit(Value, Mask: UInt8): UInt8;
begin
  Result := Var_ParallelBitsDeposit_8(Value, Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsDeposit(Value, Mask: UInt16): UInt16;
begin
  Result := Var_ParallelBitsDeposit_16(Value, Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsDeposit(Value, Mask: UInt32): UInt32;
begin
  Result := Var_ParallelBitsDeposit_32(Value, Mask);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function ParallelBitsDeposit(Value, Mask: UInt64): UInt64;
begin
  Result := Var_ParallelBitsDeposit_64(Value, Mask);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- General data <-> Hex string conversions implementation  - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'General data <-> Hex string conversions implementation'}{$ENDIF}
function DataToHexStr_SplitBytes(Split: THexStringSplit): Integer;
begin
  case Split of
    hssNibble:
      Result := 1;

    hssByte:
      Result := 2;

    hssWord:
      Result := 4;

    hss24bits:
      Result := 6;

    hssLong:
      Result := 8;

    hssQuad:
      Result := 16;

    hss80bits:
      Result := 20;

    hssOcta:
      Result := 32;

    else
      { hssNone }
      Result := 0;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(const Buffer; Size: TMemSize; HexStringFormat: THexStringFormat): String;
var
  SplitCnt: Integer;
  I: TMemSize;
  ResPos: Integer;
  DataResPos: TMemSize;
  TempStr: String;
  BuffPtr: PByte;

  procedure PutChar(NewChar: Char);
  begin
    if ((SplitCnt > 0) and (DataResPos > 0) and ((DataResPos mod TMemSize(SplitCnt)) = 0)) then
      Inc(ResPos);

    Result[ResPos] := NewChar;
    Inc(ResPos);
    Inc(DataResPos)
  end;

begin
  if (Size <> 0) then
  begin
    SplitCnt := DataToHexStr_SplitBytes(HexStringFormat.Split);
    if (SplitCnt > 0) then
      Result := StringOfChar(HexStringFormat.SplitChar,(UInt64(Size) * 2) + (Pred(UInt64(Size) * 2) div TMemSize(SplitCnt)))
    else
      SetLength(Result,Size * 2);

    ResPos := 1;
    DataResPos := 0;
    BuffPtr := @Buffer;

    for I := 0 to Pred(Size) do
    begin
      if (HexStringFormat.UpperCase) then
        TempStr := AnsiUpperCase(IntToHex(BuffPtr^, 2))
      else
        TempStr := AnsiLowerCase(IntToHex(BuffPtr^, 2));

      if (Length(TempStr) = 2) then
      begin
        PutChar(TempStr[1]);
        PutChar(TempStr[2]);
      end else
        raise EBOConversionError.CreateFmt(SDataToHexStr_InvalidStringLength, [Length(TempStr)]);

      Inc(BuffPtr);
    end;
  end else
    Result := '';
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(Arr: array of UInt8; HexStringFormat: THexStringFormat): String;
var
  SplitCnt: Integer;
  I: Integer;
  ResPos: Integer;
  DataResPos: TMemSize;
  TempStr: String;

  procedure PutChar(NewChar: Char);
  begin
    if (SplitCnt > 0) then
      if ((DataResPos > 0) and ((DataResPos mod TMemSize(SplitCnt)) = 0)) then
        Inc(ResPos);

    Result[ResPos] := NewChar;
    Inc(ResPos);
    Inc(DataResPos)
  end;

begin
  if (Length(Arr) <> 0) then
  begin
    SplitCnt := DataToHexStr_SplitBytes(HexStringFormat.Split);

    if (SplitCnt > 0) then
      Result := StringOfChar(HexStringFormat.SplitChar,(Length(Arr) * 2) + (Pred(Length(Arr) * 2) div SplitCnt))
    else
      SetLength(Result,Length(Arr) * 2);

    ResPos := 1;
    DataResPos := 0;

    for I := Low(Arr) to High(Arr) do
    begin
      if (HexStringFormat.UpperCase) then
        TempStr := AnsiUpperCase(IntToHex(Arr[I], 2))
      else
        TempStr := AnsiLowerCase(IntToHex(Arr[I], 2));

      if (Length(TempStr) = 2) then
      begin
        PutChar(TempStr[1]);
        PutChar(TempStr[2]);
      end else
        raise EBOConversionError.CreateFmt(SDataToHexStr_InvalidStringLength, [Length(TempStr)]);
    end;
  end else
    Result := '';
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(const Buffer; Size: TMemSize; Split: THexStringSplit): String;
var
  Format: THexStringFormat;
begin
  Format := DefHexStringFormat;
  Format.Split := Split;

  Result := DataToHexStr(Buffer, Size, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(Arr: array of UInt8; Split: THexStringSplit): String;
var
  Format: THexStringFormat;
begin
  Format := DefHexStringFormat;
  Format.Split := Split;

  Result := DataToHexStr(Arr, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(const Buffer; Size: TMemSize): String;
begin
  Result := DataToHexStr(Buffer, Size, DefHexStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DataToHexStr(Arr: array of UInt8): String; overload;{$IFDEF Inline} inline; {$ENDIF}
begin
  Result := DataToHexStr(Arr, DefHexStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String; out Buffer; Size: TMemSize; HexStringFormat: THexStringFormat): TMemSize;
var
  I, Cntr: Integer;
  BuffPtr: PByte;
  StrBuff: String;

  function CharInSet(C: Char; S: TSysCharSet): Boolean;
  begin
{$IF SizeOf(Char) <> 1}
    if (Ord(C) > 255) then
      Result := False
    else
{$IFEND}
      Result := AnsiChar(C) in S;
  end;

begin
  if (Length(Str) > 0) then
  begin
    if (Size <> 0) then
    begin
      Cntr := 2;
      BuffPtr := @Buffer;
      StrBuff := '$  ';  { Two spaces. }
      Result := 0;

      for I := 1 to Length(Str) do
      begin
        if (Str[I] = HexStringFormat.SplitChar) then
          Continue
        else
          if (CharInSet(Str[I], ['0'..'9', 'a'..'f', 'A'..'F'])) then
          begin
            StrBuff[Cntr] := Str[i];
            Inc(Cntr);

            if (Cntr > 3) then
            begin
              Cntr := 2;
              BuffPtr^ := UInt8(StrToInt(StrBuff));
              Inc(BuffPtr);
              Inc(Result);

              if (Result > Size) then
                raise EBOBufferTooSmall.Create(SHexStrToData_BufferTooSmall);
            end;
          end else
            EBOInvalidCharacter.CreateFmt(SHexStrToData_InvalidCharacter, [Ord(Str[I])]);
      end;
    end else
      begin
        { Only return required size, do not convert. }
        Cntr := Length(Str);
        for I := 1 to Length(Str) do
          if (Str[I] = HexStringFormat.SplitChar) then
            Dec(Cntr)
          else
            if (not CharInSet(Str[I], ['0'..'9', 'a'..'f', 'A'..'F'])) then
              raise EBOInvalidCharacter.CreateFmt(SHexStrToData_InvalidCharacter, [Ord(Str[I])]);

        Result := TMemSize(Cntr div 2);
      end;
  end else
    Result := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String; HexStringFormat: THexStringFormat): TArrayOfBytes;
var
  Len: Integer;
begin
  Len := HexStrToData(Str, nil^, 0, HexStringFormat);
  SetLength(Result, Len);
  Len := HexStrToData(Str, Result[0], Length(Result), HexStringFormat);

  if (Len <> Length(Result)) then
    SetLength(Result, Len);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String; out Buffer; Size: TMemSize; Split: THexStringSplit): TMemSize;
var
  Format: THexStringFormat;
begin
  Format := DefHexStringFormat;
  Format.Split := Split;

  Result := HexStrToData(Str, Buffer, Size, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String; Split: THexStringSplit): TArrayOfBytes;
var
  Format: THexStringFormat;
begin
  Format := DefHexStringFormat;
  Format.Split := Split;

  Result := HexStrToData(Str, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String; out Buffer; Size: TMemSize): TMemSize;
begin
  Result := HexStrToData(Str, Buffer, Size, DefHexStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function HexStrToData(const Str: String): TArrayOfBytes;
begin
  Result := HexStrToData(Str, DefHexStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Buffer; var Size: TMemSize; HexStringFormat: THexStringFormat): Boolean;
begin
  try
    Size := HexStrToData(Str, Buffer, Size, HexStringFormat);
    Result := True;
  except
    Result := False;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Arr: TArrayOfBytes; HexStringFormat: THexStringFormat): Boolean;
begin
  try
    Arr := HexStrToData(Str, HexStringFormat);
    Result := True;
  except
    Result := False;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Buffer; var Size: TMemSize; Split: THexStringSplit): Boolean;
var
  Format: THexStringFormat;
begin
  Format := DefHexStringFormat;
  Format.Split := Split;

  Result := TryHexStrToData(Str, Buffer, Size, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Arr: TArrayOfBytes; Split: THexStringSplit): Boolean;
var
  Format: THexStringFormat;
begin
  Format := DefHexStringFormat;
  Format.Split := Split;

  Result := TryHexStrToData(Str, Arr, Format);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Buffer; var Size: TMemSize): Boolean;
begin
  Result := TryHexStrToData(Str, Buffer, Size, DefHexStringFormat);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TryHexStrToData(const Str: String; out Arr: TArrayOfBytes): Boolean;
begin
  Result := TryHexStrToData(Str, Arr, DefHexStringFormat);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Binary data comparison implementation - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Binary data comparison implementation'}{$ENDIF}
function CompareData(const A; SizeA: TMemSize; const B; SizeB: TMemSize; AllowSizeDiff: Boolean = True): Integer;
var
  I: TMemSize;
  PtrA, PtrB: PByte;
begin
  Result := 0;
  if ((SizeA < SizeB) and (AllowSizeDiff)) then
    Result := -1
  else
    if ((SizeA > SizeB) and (AllowSizeDiff)) then
      Result := +1
    else
      if (SizeA = SizeB) then
      begin
        PtrA := @A;
        PtrB := @B;

        { When size is zero, this will execute no cycle. }
        for I := 1 to SizeA do
        begin
          if (PtrA^ <> PtrB^) then
          begin
            if (PtrA^ < PtrB^) then
              Result := -1
            else
              Result := +1;

            Exit;
          end;

          Inc(PtrA);
          Inc(PtrB);
        end;
      end else
        raise EBOSizeMismatch.CreateFmt(SCompareData_MismatchInDataSize, [SizeA, SizeB]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function CompareData(A,B: array of UInt8; AllowSizeDiff: Boolean = True): Integer;
var
  I: Integer;
begin
  Result := 0;

  if ((Length(A) < Length(B)) and (AllowSizeDiff)) then
    Result := -1
  else
    if ((Length(A) > Length(B)) and (AllowSizeDiff)) then
      Result := +1
    else
      if (Length(A) = Length(B)) then
      begin
        for I := Low(A) to High(A) do
          if (A[I] <> B[I]) then
          begin
            if (A[I] < B[I]) then
              Result := -1
            else
              Result := +1;

            Exit;
          end;
      end else
        EBOSizeMismatch.CreateFmt(SCompareData_MismatchInDataSize, [Length(A), Length(B)]);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Binary data equality implementation - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Binary data equality implementation'}{$ENDIF}
function SameData(const A; SizeA: TMemSize; const B; SizeB: TMemSize): Boolean;
const
  SD_BYTE_COEF = {$IFDEF 64bit}SizeOf(UInt64){$ELSE}SizeOf(UInt32){$ENDIF};
var
  I: TMemSize;
  PtrA, PtrB: Pointer;
begin
  if (SizeA = SizeB) then
  begin
    Result := True;
    PtrA := @A;
    PtrB := @B;

    { Test on whole Q/DWords. }
    if (SizeA >= (16 * SD_BYTE_COEF)) then
    begin
      for I := 1 to (SizeA div SD_BYTE_COEF) do
      begin
{$IFDEF 64bit}
        if (PUInt64(PtrA)^ <> PUInt64(PtrB)^) then
{$ELSE}
        if (PUInt32(PtrA)^ <> PUInt32(PtrB)^) then
{$ENDIF}
        begin
          Result := False;
          Exit;
        end;

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
        PtrA := Pointer(PtrUInt(PtrA) + SD_BYTE_COEF);
        PtrB := Pointer(PtrUInt(PtrB) + SD_BYTE_COEF);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
      end;

      SizeA := SizeA mod SD_BYTE_COEF;
    end;

    { Test remaining bytes. }
    for I := 1 to SizeA do  { When size is zero, this will execute no cycle. }
    begin
      if (PByte(PtrA)^ <> PByte(PtrB)^) then
      begin
        Result := False;
        Exit;
      end;

      Inc(PByte(PtrA));
      Inc(PByte(PtrB));
    end;
  end else
    Result := False;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SameData(A, B: array of UInt8): Boolean;
var
  I: Integer;
begin
  { Let's not assume the bytes are packed in the memory and compare individual
    array entries separately. }
  if (Length(A) = Length(B)) then
  begin
    Result := True;

    if (Length(A) > 0) then
      for I := Low(A) to High(A) do
        if (A[I] <> B[I]) then
        begin
          Result := False;

          Break{for I};
        end;
  end else
    Result := False;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Bit parity implementation - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit parity implementation'}{$ENDIF}
function BitParity(Value: UInt8): Boolean;
begin
  Value := ((Value) xor (Value shr 4));
  Value := ((Value) xor (Value shr 2));
  Value := ((Value) xor (Value shr 1));

  Result := (Value and 1) = 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitParity(Value: UInt16): Boolean;
begin
  Value := ((Value) xor (Value shr 8));
  Value := ((Value) xor (Value shr 4));
  Value := ((Value) xor (Value shr 2));
  Value := ((Value) xor (Value shr 1));

  Result := (Value and 1) = 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitParity(Value: UInt32): Boolean;
begin
  Value := ((Value) xor (Value shr 16));
  Value := ((Value) xor (Value shr 8));
  Value := ((Value) xor (Value shr 4));
  Value := ((Value) xor (Value shr 2));
  Value := ((Value) xor (Value shr 1));

  Result := (Value and 1) = 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function BitParity(Value: UInt64): Boolean;
begin
  Value := ((Value) xor (Value shr 32));
  Value := ((Value) xor (Value shr 16));
  Value := ((Value) xor (Value shr 8));
  Value := ((Value) xor (Value shr 4));
  Value := ((Value) xor (Value shr 2));
  Value := ((Value) xor (Value shr 1));

  Result := (Value and 1) = 0;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Unit implementation info  - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Unit implementation info'}{$ENDIF}
{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
function BitOpsFunctionIsAsm(Func: TBitOpsFunctions): Boolean;
begin
{$IFDEF PurePascal}
  Result := False;
{$ELSE}
  case Func of
    fnPopCount8:
      Result := @Var_PopCount_8 = @Fce_PopCount_8_Asm;

    fnPopCount16:
      Result := @Var_PopCount_16 = @Fce_PopCount_16_Asm;

    fnPopCount32:
      Result := @Var_PopCount_32 = @Fce_PopCount_32_Asm;

    fnPopCount64:
      Result := @Var_PopCount_64 = @Fce_PopCount_64_Asm;

    fnLZCount8:
      Result := @Var_LZCount_8 = @Fce_LZCount_8_Asm;

    fnLZCount16:
      Result := @Var_LZCount_16 = @Fce_LZCount_16_Asm;

    fnLZCount32:
      Result := @Var_LZCount_32 = @Fce_LZCount_32_Asm;

    fnLZCount64:
      Result := @Var_LZCount_64 = @Fce_LZCount_64_Asm;

    fnTZCount8:
      Result := @Var_TZCount_8 = @Fce_TZCount_8_Asm;

    fnTZCount16:
      Result := @Var_TZCount_16 = @Fce_TZCount_16_Asm;

    fnTZCount32:
      Result := @Var_TZCount_32 = @Fce_TZCount_32_Asm;

    fnTZCount64:
      Result := @Var_TZCount_64 = @Fce_TZCount_64_Asm;

    fnExtractBits8:
      Result := @Var_ExtractBits_8 = @Fce_ExtractBits_8_Asm;

    fnExtractBits16:
      Result := @Var_ExtractBits_16 = @Fce_ExtractBits_16_Asm;

    fnExtractBits32:
      Result := @Var_ExtractBits_32 = @Fce_ExtractBits_32_Asm;

    fnExtractBits64:
      Result := @Var_ExtractBits_64 = @Fce_ExtractBits_64_Asm;

    fnParallelBitsExtract8:
      Result := @Var_ParallelBitsExtract_8 = @Fce_ParallelBitsExtract_8_Asm;

    fnParallelBitsExtract16:
      Result := @Var_ParallelBitsExtract_16 = @Fce_ParallelBitsExtract_16_Asm;

    fnParallelBitsExtract32:
      Result := @Var_ParallelBitsExtract_32 = @Fce_ParallelBitsExtract_32_Asm;

    fnParallelBitsExtract64:
      Result := @Var_ParallelBitsExtract_64 = @Fce_ParallelBitsExtract_64_Asm;

    fnParallelBitsDeposit8:
      Result := @Var_ParallelBitsDeposit_8 = @Fce_ParallelBitsDeposit_8_Asm;

    fnParallelBitsDeposit16:
      Result := @Var_ParallelBitsDeposit_16 = @Fce_ParallelBitsDeposit_16_Asm;

    fnParallelBitsDeposit32:
      Result := @Var_ParallelBitsDeposit_32 = @Fce_ParallelBitsDeposit_32_Asm;

    fnParallelBitsDeposit64:
      Result := @Var_ParallelBitsDeposit_64 = @Fce_ParallelBitsDeposit_64_Asm;

    else
      raise EBOUnknownFunction.CreateFmt(SBitOpsFunctionIsAsm_UnknownFunction, [Ord(Func)]);
  end;
{$ENDIF}
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure BitOpsFunctionPas(Func: TBitOpsFunctions);
begin
  case Func of
    fnPopCount8:
      Var_PopCount_8 := Fce_PopCount_8_Pas;

    fnPopCount16:
      Var_PopCount_16 := Fce_PopCount_16_Pas;

    fnPopCount32:
      Var_PopCount_32 := Fce_PopCount_32_Pas;

    fnPopCount64:
      Var_PopCount_64 := Fce_PopCount_64_Pas;

    fnLZCount8:
      Var_LZCount_8 := Fce_LZCount_8_Pas;

    fnLZCount16:
      Var_LZCount_16 := Fce_LZCount_16_Pas;

    fnLZCount32:
      Var_LZCount_32 := Fce_LZCount_32_Pas;

    fnLZCount64:
      Var_LZCount_64 := Fce_LZCount_64_Pas;

    fnTZCount8:
      Var_TZCount_8 := Fce_TZCount_8_Pas;

    fnTZCount16:
      Var_TZCount_16 := Fce_TZCount_16_Pas;

    fnTZCount32:
      Var_TZCount_32 := Fce_TZCount_32_Pas;

    fnTZCount64:
      Var_TZCount_64 := Fce_TZCount_64_Pas;

    fnExtractBits8:
      Var_ExtractBits_8 := Fce_ExtractBits_8_Pas;

    fnExtractBits16:
      Var_ExtractBits_16 := Fce_ExtractBits_16_Pas;

    fnExtractBits32:
      Var_ExtractBits_32 := Fce_ExtractBits_32_Pas;

    fnExtractBits64:
      Var_ExtractBits_64 := Fce_ExtractBits_64_Pas;

    fnParallelBitsExtract8:
      Var_ParallelBitsExtract_8 := Fce_ParallelBitsExtract_8_Pas;

    fnParallelBitsExtract16:
      Var_ParallelBitsExtract_16 := Fce_ParallelBitsExtract_16_Pas;

    fnParallelBitsExtract32:
      Var_ParallelBitsExtract_32 := Fce_ParallelBitsExtract_32_Pas;

    fnParallelBitsExtract64:
      Var_ParallelBitsExtract_64 := Fce_ParallelBitsExtract_64_Pas;

    fnParallelBitsDeposit8:
      Var_ParallelBitsDeposit_8 := Fce_ParallelBitsDeposit_8_Pas;

    fnParallelBitsDeposit16:
      Var_ParallelBitsDeposit_16 := Fce_ParallelBitsDeposit_16_Pas;

    fnParallelBitsDeposit32:
      Var_ParallelBitsDeposit_32 := Fce_ParallelBitsDeposit_32_Pas;

    fnParallelBitsDeposit64:
      Var_ParallelBitsDeposit_64 := Fce_ParallelBitsDeposit_64_Pas;

    else
      raise EBOUnknownFunction.CreateFmt(SBitOpsFunctionPas_UnknownFunction, [Ord(Func)]);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
procedure BitOpsFunctionAsm(Func: TBitOpsFunctions);
begin
{$IFNDEF PurePascal}
  case Func of
    fnPopCount8:
      Var_PopCount_8 := Fce_PopCount_8_Asm;

    fnPopCount16:
      Var_PopCount_16 := Fce_PopCount_16_Asm;

    fnPopCount32:
      Var_PopCount_32 := Fce_PopCount_32_Asm;

    fnPopCount64:
      Var_PopCount_64 := Fce_PopCount_64_Asm;

    fnLZCount8:
      Var_LZCount_8 := Fce_LZCount_8_Asm;

    fnLZCount16:
      Var_LZCount_16 := Fce_LZCount_16_Asm;

    fnLZCount32:
      Var_LZCount_32 := Fce_LZCount_32_Asm;

    fnLZCount64:
      Var_LZCount_64 := Fce_LZCount_64_Asm;

    fnTZCount8:
      Var_TZCount_8 := Fce_TZCount_8_Asm;

    fnTZCount16:
      Var_TZCount_16 := Fce_TZCount_16_Asm;

    fnTZCount32:
      Var_TZCount_32 := Fce_TZCount_32_Asm;

    fnTZCount64:
      Var_TZCount_64 := Fce_TZCount_64_Asm;

    fnExtractBits8:
      Var_ExtractBits_8 := Fce_ExtractBits_8_Asm;

    fnExtractBits16:
      Var_ExtractBits_16 := Fce_ExtractBits_16_Asm;

    fnExtractBits32:
      Var_ExtractBits_32 := Fce_ExtractBits_32_Asm;

    fnExtractBits64:
      Var_ExtractBits_64 := Fce_ExtractBits_64_Asm;

    fnParallelBitsExtract8:
      Var_ParallelBitsExtract_8 := Fce_ParallelBitsExtract_8_Asm;

    fnParallelBitsExtract16:
      Var_ParallelBitsExtract_16 := Fce_ParallelBitsExtract_16_Asm;

    fnParallelBitsExtract32:
      Var_ParallelBitsExtract_32 := Fce_ParallelBitsExtract_32_Asm;

    fnParallelBitsExtract64:
      Var_ParallelBitsExtract_64 := Fce_ParallelBitsExtract_64_Asm;

    fnParallelBitsDeposit8:
      Var_ParallelBitsDeposit_8 := Fce_ParallelBitsDeposit_8_Asm;

    fnParallelBitsDeposit16:
      Var_ParallelBitsDeposit_16 := Fce_ParallelBitsDeposit_16_Asm;

    fnParallelBitsDeposit32:
      Var_ParallelBitsDeposit_32 := Fce_ParallelBitsDeposit_32_Asm;

    fnParallelBitsDeposit64:
      Var_ParallelBitsDeposit_64 := Fce_ParallelBitsDeposit_64_Asm;

    else
      raise EBOUnknownFunction.CreateFmt(BitOpsFunctionAsm_UnknownFunction, [Ord(Func)]);
  end;
{$ENDIF}
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
procedure BitOpsFunctionAssign(Func: TBitOpsFunctions; AssignASM: Boolean);
begin
{$IFNDEF PurePascal}
  if (AssignASM) then
    BitOpsFunctionAsm(Func)
  else
{$ENDIF}
    BitOpsFunctionPas(Func);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Unit initialization implementation  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Unit initialization implementation'}{$ENDIF}
procedure LoadDefaultFunctions;
var
  I: TBitOpsFunctions;
begin
  for I := Low(TBitOpsFunctions) to High(TBitOpsFunctions) do
    BitOpsFunctionPas(I);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure Initialize;
begin
  LoadDefaultFunctions;

{$IF DEFINED(BO_AllowASMExtensions) AND NOT DEFINED(PurePascal)}
  with TCPUIdentification.Create do
  try
    { PopCount. }
    BitOpsFunctionAssign(fnPopCount8, Info.SupportedExtensions.POPCNT);
    BitOpsFunctionAssign(fnPopCount16, Info.SupportedExtensions.POPCNT);
    BitOpsFunctionAssign(fnPopCount32, Info.SupportedExtensions.POPCNT);
    BitOpsFunctionAssign(fnPopCount64, Info.SupportedExtensions.POPCNT);

    { LZCount. }
    BitOpsFunctionAssign(fnLZCount8, Info.ExtendedProcessorFeatures.LZCNT);
    BitOpsFunctionAssign(fnLZCount16, Info.ExtendedProcessorFeatures.LZCNT);
    BitOpsFunctionAssign(fnLZCount32, Info.ExtendedProcessorFeatures.LZCNT);
    BitOpsFunctionAssign(fnLZCount64, Info.ExtendedProcessorFeatures.LZCNT);

    { TZCount. }
    BitOpsFunctionAssign(fnTZCount8, Info.ProcessorFeatures.BMI1);
    BitOpsFunctionAssign(fnTZCount16, Info.ProcessorFeatures.BMI1);
    BitOpsFunctionAssign(fnTZCount32, Info.ProcessorFeatures.BMI1);
    BitOpsFunctionAssign(fnTZCount64, Info.ProcessorFeatures.BMI1);

    { ExtractBits. }
    BitOpsFunctionAssign(fnExtractBits8, Info.ProcessorFeatures.BMI1);
    BitOpsFunctionAssign(fnExtractBits16, Info.ProcessorFeatures.BMI1);
    BitOpsFunctionAssign(fnExtractBits32, Info.ProcessorFeatures.BMI1);
    BitOpsFunctionAssign(fnExtractBits64, Info.ProcessorFeatures.BMI1);

    { ParallelBitsExtract. }
    BitOpsFunctionAssign(fnParallelBitsExtract8, Info.ProcessorFeatures.BMI2);
    BitOpsFunctionAssign(fnParallelBitsExtract16, Info.ProcessorFeatures.BMI2);
    BitOpsFunctionAssign(fnParallelBitsExtract32, Info.ProcessorFeatures.BMI2);
    BitOpsFunctionAssign(fnParallelBitsExtract64, Info.ProcessorFeatures.BMI2 {$IFNDEF x64}and Info.SupportedExtensions.POPCNT{$ENDIF});

    { ParallelBitsDeposit. }
    BitOpsFunctionAssign(fnParallelBitsDeposit8, Info.ProcessorFeatures.BMI2);
    BitOpsFunctionAssign(fnParallelBitsDeposit16, Info.ProcessorFeatures.BMI2);
    BitOpsFunctionAssign(fnParallelBitsDeposit32, Info.ProcessorFeatures.BMI2);
    BitOpsFunctionAssign(fnParallelBitsDeposit64, Info.ProcessorFeatures.BMI2 {$IFNDEF x64}and Info.SupportedExtensions.POPCNT and Info.ProcessorFeatures.CMOV{$ENDIF});
  finally
    Free;
  end;
{$IFEND}
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

initialization
  Initialize;

end.
