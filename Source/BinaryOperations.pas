{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$INCLUDE BinaryOperations.Config.inc}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Binary operations library implementation.
/// </summary>
/// <remarks>
///   <para>
///     Dependencies:
///   </para>
///   <list type="bullet">
///     <item>
///       Lib.TypeDefinitions - github.com/dompiotr85/Lib.TypeDefinitions
///     </item>
///     <item>
///       * Lib.CPUIdentification -
///       github.com/dompiotr85/Lib.CPUIdentification
///     </item>
///   </list>
///   <para>
///     * <i>Lib.CPUIdentification is required only when
///     BO_AllowASMExtensions directive is defined and PurePascal directive
///     is not defined.</i>
///   </para>
///   <para>
///     Version 0.1.2
///   </para>
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
unit BinaryOperations;

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

{$IF CompilerVersion >= 17}  { Delphi 2005+ }
 {$DEFINE CanInline}
{$ELSE}
 {$UNDEF CanInline}
{$IFEND}

{$IFOPT Q+}
 {$DEFINE OverflowChecks}
{$ENDIF}

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  TypeDefinitions;

type
  EBinaryOperations = Exception;

{-------------------------------------------------------------------------------
  Integer number <-> Bit string conversions.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Integer number <-> Bit string conversions'}{$ENDIF}
type
  TBitStringSplit = (bssNone, bss4bits, bss8bits, bss16bits, bss32bits);

  TBitStringFormat = record
    Split: TBitStringSplit;
    SetBitChar: Char;
    ZeroBitChar: Char;
    SplitChar: Char;
  end;

const
  DefBitStringFormat: TBitStringFormat =
    (Split: bssNone; SetBitChar: '1'; ZeroBitChar: '0'; SplitChar: ' ');

function NumberToBitString(Number: UInt64; Bits: UInt8; BitStringFormat: TBitStringFormat): String;

function NumberToBitStr(Number: UInt8; BitStringFormat: TBitStringFormat): String; overload;  {$IF DEFINED(CanInline)}inline;{$IFEND}
function NumberToBitStr(Number: UInt16; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function NumberToBitStr(Number: UInt32; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function NumberToBitStr(Number: UInt64; BitStringFormat: TBitStringFormat): String; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}

function NumberToBitStr(Number: UInt8; Split: TBitStringSplit): String; overload;
function NumberToBitStr(Number: UInt16; Split: TBitStringSplit): String; overload;
function NumberToBitStr(Number: UInt32; Split: TBitStringSplit): String; overload;
function NumberToBitStr(Number: UInt64; Split: TBitStringSplit): String; overload;

function NumberToBitStr(Number: UInt8): String; overload;  {$IFDEF CanInline}inline;{$ENDIF}
function NumberToBitStr(Number: UInt16): String; overload; {$IFDEF CanInline}inline;{$ENDIF}
function NumberToBitStr(Number: UInt32): String; overload; {$IFDEF CanInline}inline;{$ENDIF}
function NumberToBitStr(Number: UInt64): String; overload; {$IFDEF CanInline}inline;{$ENDIF}

function BitStrToNumber(const BitString: String; BitStringFormat: TBitStringFormat): UInt64; overload;
function BitStrToNumber(const BitString: String): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

function TryBitStrToNumber(const BitString: String; out Value: UInt8; BitStringFormat: TBitStringFormat): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt16; BitStringFormat: TBitStringFormat): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt32; BitStringFormat: TBitStringFormat): Boolean; overload;
function TryBitStrToNumber(const BitString: String; out Value: UInt64; BitStringFormat: TBitStringFormat): Boolean; overload;

function TryBitStrToNumber(const BitString: String; out Value: UInt8): Boolean; overload;  {$IFDEF CanInline}inline;{$ENDIF}
function TryBitStrToNumber(const BitString: String; out Value: UInt16): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}
function TryBitStrToNumber(const BitString: String; out Value: UInt32): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}
function TryBitStrToNumber(const BitString: String; out Value: UInt64): Boolean; overload; {$IFDEF CanInline}inline;{$ENDIF}

function BitStrToNumberDef(const BitString: String; Default: UInt64; BitStringFormat: TBitStringFormat): UInt64; overload;
function BitStrToNumberDef(const BitString: String; Default: UInt64): UInt64; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Rotate left (ROL).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left (ROL)'}{$ENDIF}
function ROL(Value: UInt8; Shift: UInt8): UInt8; overload;
function ROL(Value: UInt16; Shift: UInt8): UInt16; overload;
function ROL(Value: UInt32; Shift: UInt8): UInt32; overload;
function ROL(Value: UInt64; Shift: UInt8): UInt64; overload;

procedure ROLValue(var Value: UInt8; Shift: UInt8); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure ROLValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ROLValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ROLValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Rotate right (ROR).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right (ROR)'}{$ENDIF}
function ROR(Value: UInt8; Shift: UInt8): UInt8; overload;
function ROR(Value: UInt16; Shift: UInt8): UInt16; overload;
function ROR(Value: UInt32; Shift: UInt8): UInt32; overload;
function ROR(Value: UInt64; Shift: UInt8): UInt64; overload;

procedure RORValue(var Value: UInt8; Shift: UInt8); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure RORValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RORValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RORValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Rotate left with carry (RCL).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left with carry (RCL)'}{$ENDIF}
function RCLCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8; overload;
function RCLCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16; overload;
function RCLCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32; overload;
function RCLCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64; overload;

function RCL(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8; overload;   {$IFDEF CanInline}inline;{$ENDIF}
function RCL(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCL(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCL(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure RCLValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure RCLValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCLValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Rotate right with carry (RCR).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right with carry (RCR)'}{$ENDIF}
function RCRCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8; overload;
function RCRCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16; overload;
function RCRCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32; overload;
function RCRCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64; overload;

function RCR(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8; overload;   {$IFDEF CanInline}inline;{$ENDIF}
function RCR(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCR(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function RCR(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure RCRValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool); overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure RCRValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure RCRValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Arithmetic left shift (SAL).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic left shift (SAL)'}{$ENDIF}
function SAL(Value: UInt8; Shift: UInt8): UInt8; overload;   {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function SAL(Value: UInt16; Shift: UInt8): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function SAL(Value: UInt32; Shift: UInt8): UInt32; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function SAL(Value: UInt64; Shift: UInt8): UInt64; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}

procedure SALValue(var Value: UInt8; Shift: UInt8); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure SALValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SALValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SALValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Arithmetic right shift (SAR).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic right shift (SAR)'}{$ENDIF}
function SAR(Value: UInt8; Shift: UInt8): UInt8; overload;
function SAR(Value: UInt16; Shift: UInt8): UInt16; overload;
function SAR(Value: UInt32; Shift: UInt8): UInt32; overload;
function SAR(Value: UInt64; Shift: UInt8): UInt64; overload;

procedure SARValue(var Value: UInt8; Shift: UInt8); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure SARValue(var Value: UInt16; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SARValue(var Value: UInt32; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SARValue(var Value: UInt64; Shift: UInt8); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Endianity swap.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Endianity swap'}{$ENDIF}
function EndianSwap(Value: UInt16): UInt16; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function EndianSwap(Value: UInt32): UInt32; overload;
function EndianSwap(Value: UInt64): UInt64; overload;

procedure EndianSwapValue(var Value: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure EndianSwapValue(var Value: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure EndianSwapValue(var Value: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure EndianSwap(var Buffer; Size: TMemSize); overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit test (BT).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test (BT)'}{$ENDIF}
function BT(Value: UInt8; Bit: UInt8): ByteBool; overload;  {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function BT(Value: UInt16; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function BT(Value: UInt32; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
function BT(Value: UInt64; Bit: UInt8): ByteBool; overload; {$IF DEFINED(CanInline) AND DEFINED(PurePascal)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit test and set (BTS).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set (BTS)'}{$ENDIF}
function BTS(var Value: UInt8; Bit: UInt8): ByteBool; overload;
function BTS(var Value: UInt16; Bit: UInt8): ByteBool; overload;
function BTS(var Value: UInt32; Bit: UInt8): ByteBool; overload;
function BTS(var Value: UInt64; Bit: UInt8): ByteBool; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit test and reset (BTR).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and reset (BTR)'}{$ENDIF}
function BTR(var Value: UInt8; Bit: UInt8): ByteBool; overload;
function BTR(var Value: UInt16; Bit: UInt8): ByteBool; overload;
function BTR(var Value: UInt32; Bit: UInt8): ByteBool; overload;
function BTR(var Value: UInt64; Bit: UInt8): ByteBool; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit test and complement (BTC).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and complement (BTC)'}{$ENDIF}
function BTC(var Value: UInt8; Bit: UInt8): ByteBool; overload;
function BTC(var Value: UInt16; Bit: UInt8): ByteBool; overload;
function BTC(var Value: UInt32; Bit: UInt8): ByteBool; overload;
function BTC(var Value: UInt64; Bit: UInt8): ByteBool; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit test and set to a given value.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set to a given value'}{$ENDIF}
function BitSetTo(var Value: UInt8; Bit: UInt8; NewValue: ByteBool): ByteBool; overload;  {$IFDEF CanInline}inline;{$ENDIF}
function BitSetTo(var Value: UInt16; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
function BitSetTo(var Value: UInt32; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
function BitSetTo(var Value: UInt64; Bit: UInt8; NewValue: ByteBool): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit scan forward (BSF)
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan forward (BSF)'}{$ENDIF}
function BSF(Value: UInt8): Int32; overload;
function BSF(Value: UInt16): Int32; overload;
function BSF(Value: UInt32): Int32; overload;
function BSF(Value: UInt64): Int32; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Bit scan reversed (BSR).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan reversed (BSR)'}{$ENDIF}
function BSR(Value: UInt8): Int32; overload;
function BSR(Value: UInt16): Int32; overload;
function BSR(Value: UInt32): Int32; overload;
function BSR(Value: UInt64): Int32; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Population count.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Population count'}{$ENDIF}
var
  Var_PopCount_8: function (Value: UInt8): Int32; register;
  Var_PopCount_16: function (Value: UInt16): Int32; register;
  Var_PopCount_32: function (Value: UInt32): Int32; register;
  Var_PopCount_64: function (Value: UInt64): Int32; register;

function PopCount(Value: UInt8): Int32;  overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function PopCount(Value: UInt16): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function PopCount(Value: UInt32): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function PopCount(Value: UInt64): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Nibble manipulation.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Population count'}{$ENDIF}
function GetHighNibble(Value: UInt8): TNibble; {$IFDEF CanInline}inline;{$ENDIF}
function GetLowNibble(Value: UInt8): TNibble;  {$IFDEF CanInline}inline;{$ENDIF}

function SetHighNibble(Value: UInt8; SetTo: TNibble): UInt8; {$IFDEF CanInline}inline;{$ENDIF}
function SetLowNibble(Value: UInt8; SetTo: TNibble): UInt8;  {$IFDEF CanInline}inline;{$ENDIF}

procedure SetHighNibbleValue(var Value: UInt8; SetTo: TNibble); {$IFDEF CanInline}inline;{$ENDIF}
procedure SetLowNibbleValue(var Value: UInt8; SetTo: TNibble);  {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Get flag state.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Get flag state'}{$ENDIF}
function GetFlagState(Value, FlagBitmask: UInt8; ExactMatch: Boolean = False): Boolean; overload;
function GetFlagState(Value, FlagBitmask: UInt16; ExactMatch: Boolean = False): Boolean; overload;
function GetFlagState(Value, FlagBitmask: UInt32; ExactMatch: Boolean = False): Boolean; overload;
function GetFlagState(Value, FlagBitmask: UInt64; ExactMatch: Boolean = False): Boolean; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Set flag.

  Functions with bits noted in name (*_8, *_16, ...) are there mainly for older
  versions of Delphi (up to Delphi 2007), because they are not able to
  distinguish what overloaded function to call (some problem with open array
  parameter parsing).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag'}{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt8): UInt8; overload;   {$IFDEF CanInline}inline;{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt16): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt32): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt64): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure SetFlagValue(var Value: UInt8; FlagBitmask: UInt8); overload;   {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagValue(var Value: UInt16; FlagBitmask: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagValue(var Value: UInt32; FlagBitmask: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagValue(var Value: UInt64; FlagBitmask: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}

function SetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
function SetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
function SetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
function SetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;

function SetFlags(Value: UInt8; Flags: array of UInt8): UInt8; overload;
function SetFlags(Value: UInt16; Flags: array of UInt16): UInt16; overload;
function SetFlags(Value: UInt32; Flags: array of UInt32): UInt32; overload;
function SetFlags(Value: UInt64; Flags: array of UInt64): UInt64; overload;

procedure SetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
procedure SetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
procedure SetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
procedure SetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);

procedure SetFlagsValue(var Value: UInt8; Flags: array of UInt8); overload;
procedure SetFlagsValue(var Value: UInt16; Flags: array of UInt16); overload;
procedure SetFlagsValue(var Value: UInt32; Flags: array of UInt32); overload;
procedure SetFlagsValue(var Value: UInt64; Flags: array of UInt64); overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Reset flag.

  Functions with bits noted in name (*_8, *_16, ...) are there mainly for older
  versions of Delphi (up to Delphi 2007), because they are not able to
  distinguish what overloaded function to call (some problem with open array
  parameter parsing).
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Reset flag'}{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt8): UInt8; overload;   {$IFDEF CanInline}inline;{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt16): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt32): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt64): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

procedure ResetFlagValue(var Value: UInt8; FlagBitmask: UInt8); overload;   {$IFDEF CanInline}inline;{$ENDIF}
procedure ResetFlagValue(var Value: UInt16; FlagBitmask: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ResetFlagValue(var Value: UInt32; FlagBitmask: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ResetFlagValue(var Value: UInt64; FlagBitmask: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}

function ResetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
function ResetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
function ResetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
function ResetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;

function ResetFlags(Value: UInt8; Flags: array of UInt8): UInt8; overload;
function ResetFlags(Value: UInt16; Flags: array of UInt16): UInt16; overload;
function ResetFlags(Value: UInt32; Flags: array of UInt32): UInt32; overload;
function ResetFlags(Value: UInt64; Flags: array of UInt64): UInt64; overload;

procedure ResetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
procedure ResetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
procedure ResetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
procedure ResetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);

procedure ResetFlagsValue(var Value: UInt8; Flags: array of UInt8); overload;
procedure ResetFlagsValue(var Value: UInt16; Flags: array of UInt16); overload;
procedure ResetFlagsValue(var Value: UInt32; Flags: array of UInt32); overload;
procedure ResetFlagsValue(var Value: UInt64; Flags: array of UInt64); overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Set flag state.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag state'}{$ENDIF}
function SetFlagState(Value, FlagBitmask: UInt8; NewState: Boolean): UInt8; overload;
function SetFlagState(Value, FlagBitmask: UInt16; NewState: Boolean): UInt16; overload;
function SetFlagState(Value, FlagBitmask: UInt32; NewState: Boolean): UInt32; overload;
function SetFlagState(Value, FlagBitmask: UInt64; NewState: Boolean): UInt64; overload;

procedure SetFlagStateValue(var Value: UInt8; FlagBitmask: UInt8; NewState: Boolean); overload;   {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagStateValue(var Value: UInt16; FlagBitmask: UInt16; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagStateValue(var Value: UInt32; FlagBitmask: UInt32; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetFlagStateValue(var Value: UInt64; FlagBitmask: UInt64; NewState: Boolean); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Get bits.

  Returns contiguous segment of bits from passed Value, selected by a bit range.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Get bits'}{$ENDIF}
function GetBits(Value: UInt8; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt8; overload;
function GetBits(Value: UInt16; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt16; overload;
function GetBits(Value: UInt32; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt32; overload;
function GetBits(Value: UInt64; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt64; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Set bits.

  Replaces contiguous segment of bits in Value by corresponding bits from
  NewBits.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Set bits'}{$ENDIF}
function SetBits(Value, NewBits: UInt8; FromBit, ToBit: Integer): UInt8; overload;
function SetBits(Value, NewBits: UInt16; FromBit, ToBit: Integer): UInt16; overload;
function SetBits(Value, NewBits: UInt32; FromBit, ToBit: Integer): UInt32; overload;
function SetBits(Value, NewBits: UInt64; FromBit, ToBit: Integer): UInt64; overload;

procedure SetBitsValue(var Value: UInt8; NewBits: UInt8; FromBit, ToBit: Integer); overload;   {$IFDEF CanInline}inline;{$ENDIF}
procedure SetBitsValue(var Value: UInt16; NewBits: UInt16; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetBitsValue(var Value: UInt32; NewBits: UInt32; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure SetBitsValue(var Value: UInt64; NewBits: UInt64; FromBit, ToBit: Integer); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Reverse bits.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Reverse bits'}{$ENDIF}
function ReverseBits(Value: UInt8): UInt8; overload;
function ReverseBits(Value: UInt16): UInt16; overload;
function ReverseBits(Value: UInt32): UInt32; overload;
function ReverseBits(Value: UInt64): UInt64; overload;

procedure ReverseBitsValue(var Value: UInt8); overload;  {$IFDEF CanInline}inline;{$ENDIF}
procedure ReverseBitsValue(var Value: UInt16); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ReverseBitsValue(var Value: UInt32); overload; {$IFDEF CanInline}inline;{$ENDIF}
procedure ReverseBitsValue(var Value: UInt64); overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Leading zero count.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Leading zero count'}{$ENDIF}
var
  Var_LZCount_8: function (Value: UInt8): Int32; register;
  Var_LZCount_16: function (Value: UInt16): Int32; register;
  Var_LZCount_32: function (Value: UInt32): Int32; register;
  Var_LZCount_64: function (Value: UInt64): Int32; register;

function LZCount(Value: UInt8): Int32; overload;  {$IF DEFINED(CanInline)}inline;{$IFEND}
function LZCount(Value: UInt16): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function LZCount(Value: UInt32): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function LZCount(Value: UInt64): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Trailing zero count.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Trailing zero count'}{$ENDIF}
var
  Var_TZCount_8: function (Value: UInt8): Int32; register;
  Var_TZCount_16: function (Value: UInt16): Int32; register;
  Var_TZCount_32: function (Value: UInt32): Int32; register;
  Var_TZCount_64: function (Value: UInt64): Int32; register;

function TZCount(Value: UInt8): Int32; overload;  {$IF DEFINED(CanInline)}inline;{$IFEND}
function TZCount(Value: UInt16): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function TZCount(Value: UInt32): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function TZCount(Value: UInt64): Int32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Extract bits.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Extract bits'}{$ENDIF}
var
  Var_ExtractBits_8: function (Value: UInt8; Start, Length: UInt8): UInt8; register;
  Var_ExtractBits_16: function (Value: UInt16; Start, Length: UInt8): UInt16; register;
  Var_ExtractBits_32: function (Value: UInt32; Start, Length: UInt8): UInt32; register;
  Var_ExtractBits_64: function (Value: UInt64; Start, Length: UInt8): UInt64; register;

function ExtractBits(Value: UInt8; Start, Length: UInt8): UInt8; overload;   {$IF DEFINED(CanInline)}inline;{$IFEND}
function ExtractBits(Value: UInt16; Start, Length: UInt8): UInt16; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function ExtractBits(Value: UInt32; Start, Length: UInt8): UInt32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function ExtractBits(Value: UInt64; Start, Length: UInt8): UInt64; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Parallel bits extract.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits extract'}{$ENDIF}
var
  Var_ParallelBitsExtract_8: function (Value, Mask: UInt8): UInt8; register;
  Var_ParallelBitsExtract_16: function (Value, Mask: UInt16): UInt16; register;
  Var_ParallelBitsExtract_32: function (Value, Mask: UInt32): UInt32; register;
  Var_ParallelBitsExtract_64: function (Value, Mask: UInt64): UInt64; register;

function ParallelBitsExtract(Value, Mask: UInt8): UInt8; overload;   {$IF DEFINED(CanInline)}inline;{$IFEND}
function ParallelBitsExtract(Value, Mask: UInt16): UInt16; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function ParallelBitsExtract(Value, Mask: UInt32): UInt32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function ParallelBitsExtract(Value, Mask: UInt64): UInt64; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{-------------------------------------------------------------------------------
  Parallel bits deposit.
-------------------------------------------------------------------------------}
{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits deposit'}{$ENDIF}
var
  Var_ParallelBitsDeposit_8: function (Value, Mask: UInt8): UInt8; register;
  Var_ParallelBitsDeposit_16: function (Value, Mask: UInt16): UInt16; register;
  Var_ParallelBitsDeposit_32: function (Value, Mask: UInt32): UInt32; register;
  Var_ParallelBitsDeposit_64: function (Value, Mask: UInt64): UInt64; register;

function ParallelBitsDeposit(Value, Mask: UInt8): UInt8; overload;   {$IF DEFINED(CanInline)}inline;{$IFEND}
function ParallelBitsDeposit(Value, Mask: UInt16): UInt16; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function ParallelBitsDeposit(Value, Mask: UInt32): UInt32; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
function ParallelBitsDeposit(Value, Mask: UInt64): UInt64; overload; {$IF DEFINED(CanInline)}inline;{$IFEND}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
{$IF DEFINED(BO_AllowASMExtensions) AND NOT DEFINED(PurePascal)}
  CPUIdentification,
{$IFEND}
  BinaryOperations.Consts;

{ ASM_MachineCode --------------------------------------------------------------

  When defined, some ASM instructions are inserted into byte stream directly as
  a machine code. It is there because not all compilers supports, and therefore
  can compile, such instructions. As I am not able to tell which 32-bit delphi
  compilers do support them, I am assuming none of them do. I am also assuming
  that all 64-bit delphi compilers are supporting the instructions.
  Has no meaning when PurePascal is defined. }
{$DEFINE ASM_MachineCode}

{$IFDEF SUPPORTS_REGION}{$REGION 'Integer number <-> Bit string conversions'}{$ENDIF}
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

function NumberToBitStr(Number: UInt8; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 8, BitStringFormat);
end;

function NumberToBitStr(Number: UInt16; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 16, BitStringFormat);
end;

function NumberToBitStr(Number: UInt32; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 32, BitStringFormat);
end;

function NumberToBitStr(Number: UInt64; BitStringFormat: TBitStringFormat): String;
begin
  Result := NumberToBitString(Number, 64, BitStringFormat);
end;

function NumberToBitStr(Number: UInt8; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

function NumberToBitStr(Number: UInt16; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

function NumberToBitStr(Number: UInt32; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

function NumberToBitStr(Number: UInt64; Split: TBitStringSplit): String;
var
  Format: TBitStringFormat;
begin
  Format := DefBitStringFormat;
  Format.Split := Split;
  Result := NumberToBitStr(Number, Format);
end;

function NumberToBitStr(Number: UInt8): String;
begin
  Result := NumberToBitString(Number, 8, DefBitStringFormat);
end;

function NumberToBitStr(Number: UInt16): String;
begin
  Result := NumberToBitString(Number, 16, DefBitStringFormat);
end;

function NumberToBitStr(Number: UInt32): String;
begin
  Result := NumberToBitString(Number, 32, DefBitStringFormat);
end;

function NumberToBitStr(Number: UInt64): String;
begin
  Result := NumberToBitString(Number, 64, DefBitStringFormat);
end;

function BitStrToNumber(
  const BitString: String; BitStringFormat: TBitStringFormat): UInt64;
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to Length(BitString) do
  begin
    if (BitString[i] <> BitStringFormat.SplitChar) then
    begin
      Result := Result shl 1;

      if (BitString[i] = BitStringFormat.SetBitChar) then
        Result := Result or 1
      else
        if (BitString[i] <> BitStringFormat.ZeroBitChar) then
          raise EBinaryOperations.CreateFmt(SBitStrToNumber_UnknownCharacterInBitstring, [Ord(BitString[i])]);
    end else
      Continue{for I};
  end;
end;

function BitStrToNumber(const BitString: String): UInt64;
begin
  Result := BitStrToNumber(BitString, DefBitStringFormat);
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt8; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := UInt8(BitStrToNumber(BitString, BitStringFormat));
    Result := True;
  except
    Result := False;
  end;
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt16; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := UInt16(BitStrToNumber(BitString, BitStringFormat));
    Result := True;
  except
    Result := False;
  end;
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt32; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := UInt32(BitStrToNumber(BitString, BitStringFormat));
    Result := True;
  except
    Result := False;
  end;
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt64; BitStringFormat: TBitStringFormat): Boolean;
begin
  try
    Value := BitStrToNumber(BitString, BitStringFormat);
    Result := True;
  except
    Result := False;
  end;
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt8): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt16): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt32): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

function TryBitStrToNumber(const BitString: String; out Value: UInt64): Boolean;
begin
  Result := TryBitStrToNumber(BitString, Value, DefBitStringFormat);
end;

function BitStrToNumberDef(const BitString: String; Default: UInt64; BitStringFormat: TBitStringFormat): UInt64;
begin
  if (not TryBitStrToNumber(BitString, Result, BitStringFormat)) then
    Result := Default;
end;

function BitStrToNumberDef(const BitString: String; Default: UInt64): UInt64;
begin
  if (not TryBitStrToNumber(BitString, Result, DefBitStringFormat)) then
    Result := Default;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left (ROL)'}{$ENDIF}
function ROL(Value: UInt8; Shift: UInt8): UInt8;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AL, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  ROL       AL, CL
end;
{$ELSE}
begin
  Shift := Shift and $07;
  Result := UInt8((Value shl Shift) or (Value shr (8 - Shift)));
end;
{$ENDIF ~PurePascal}

function ROL(Value: UInt16; Shift: UInt8): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  ROL       AX, CL
end;
{$ELSE}
begin
  Shift := Shift and $0F;
  Result := UInt16((Value shl Shift) or (Value shr (16 - Shift)));
end;
{$ENDIF ~PurePascal}

function ROL(Value: UInt32; Shift: UInt8): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  ROL       EAX, CL
end;
{$ELSE}
begin
  Shift := Shift and $1F;
  Result := UInt32((Value shl Shift) or (Value shr (32 - Shift)));
end;
{$ENDIF ~PurePascal}

function ROL(Value: UInt64; Shift: UInt8): UInt64;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  MOV       CL, Shift
  ROL       RAX, CL
 {$ELSE}
  MOV       ECX, EAX
  AND       ECX, $3F
  CMP       ECX, 32

  JAE       @Above31

@Below32:
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]
  CMP       ECX, 0
  JE        @FuncEnd

  MOV       DWORD PTR [Value], EDX
  JMP       @Rotate

@Above31:
  MOV       EDX, DWORD PTR [Value]
  MOV       EAX, DWORD PTR [Value + 4]
  JE        @FuncEnd

  AND       ECX, $1F

@Rotate:
  SHLD      EDX, EAX, CL
  SHL       EAX, CL
  PUSH      EAX
  MOV       EAX, DWORD PTR [Value]
  XOR       CL, 31
  INC       CL
  SHR       EAX, CL
  POP       ECX
  OR        EAX, ECX

@FuncEnd:
 {$ENDIF ~x64}
end;
{$ELSE}
begin
  Shift := Shift and $3F;
  Result := UInt64((Value shl Shift) or (Value shr (64 - Shift)));
end;
{$ENDIF ~PurePascal}

procedure ROLValue(var Value: UInt8; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;

procedure ROLValue(var Value: UInt16; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;

procedure ROLValue(var Value: UInt32; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;

procedure ROLValue(var Value: UInt64; Shift: UInt8);
begin
  Value := ROL(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right (ROR)'}{$ENDIF}
function ROR(Value: UInt8; Shift: UInt8): UInt8;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AL, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  ROR       AL, CL
end;
{$ELSE}
begin
  Shift := Shift and $07;
  Result := UInt8((Value shr Shift) or (Value shl (8 - Shift)));
end;
{$ENDIF ~PurePascal}

function ROR(Value: UInt16; Shift: UInt8): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  ROR       AX, CL
end;
{$ELSE}
begin
  Shift := Shift and $0F;
  Result := UInt16((Value shr Shift) or (Value shl (16 - Shift)));
end;
{$ENDIF ~PurePascal}

function ROR(Value: UInt32; Shift: UInt8): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  ROR       EAX, CL
end;
{$ELSE}
begin
  Shift := Shift and $1F;
  Result := UInt32((Value shr Shift) or (Value shl (32 - Shift)));
end;
{$ENDIF ~PurePascal}

function ROR(Value: UInt64; Shift: UInt8): UInt64;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  MOV       CL, Shift
  ROR       RAX, CL
 {$ELSE}
  MOV       ECX, EAX
  AND       ECX, $3F
  CMP       ECX, 32

  JAE       @Above31

@Below32:
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]
  CMP       ECX, 0
  JE        @FuncEnd

  MOV       DWORD PTR [Value], EDX
  JMP       @Rotate

@Above31:
  MOV       EDX, DWORD PTR [Value]
  MOV       EAX, DWORD PTR [Value + 4]
  JE        @FuncEnd

  AND       ECX,  $1F

@Rotate:
  SHRD      EDX, EAX, CL
  SHR       EAX, CL
  PUSH      EAX
  MOV       EAX, DWORD PTR [Value]
  XOR       CL, 31
  INC       CL
  SHL       EAX, CL
  POP       ECX
  OR        EAX, ECX

@FuncEnd:
 {$ENDIF ~x64}
end;
{$ELSE}
begin
  Shift := Shift and $3F;
  Result := UInt64((Value shr Shift) or (Value shl (64 - Shift)));
end;
{$ENDIF ~PurePascal}

procedure RORValue(var Value: UInt8; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;

procedure RORValue(var Value: UInt16; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;

procedure RORValue(var Value: UInt32; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;

procedure RORValue(var Value: UInt64; Shift: UInt8);
begin
  Value := ROR(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate left with carry (RCL)'}{$ENDIF}
function RCLCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AL, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCL       AL, CL
  SETC      BYTE PTR [CF]
 {$ELSE}
  XCHG      EDX, ECX
  SHR       BYTE PTR [EDX], 1
  RCL       AL, CL
  SETC      BYTE PTR [EDX]
 {$ENDIF ~x64}
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function RCLCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCL       AX, CL
  SETC      BYTE PTR [CF]
 {$ELSE}
  XCHG      EDX, ECX
  SHR       BYTE PTR [EDX], 1
  RCL       AX, CL
  SETC      BYTE PTR [EDX]
 {$ENDIF ~x64}
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function RCLCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCL       EAX, CL
  SETC      BYTE PTR [CF]
 {$ELSE}
  XCHG      EDX, ECX
  SHR       BYTE PTR [EDX], 1
  RCL       EAX, CL
  SETC      BYTE PTR [EDX]
 {$ENDIF ~x64}
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function RCLCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64;
{$IFNDEF PurePascal} register; assembler;
 {$IFDEF x64}
asm
  MOV       RAX, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCL       RAX, CL
  SETC      BYTE PTR [CF]
end;
 {$ELSE}
var
  TempShift: UInt32;
asm
  PUSH      EBX

  AND       EAX, $3F
  MOV       DWORD PTR [TempShift], EAX
  MOV       ECX, EAX
  MOV       EBX, EDX

  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]
  CMP       ECX, 32

  JE        @Exactly32
  JA        @Above32

  { Shift is below 32. }
  TEST      ECX,  ECX
  JZ        @FuncEnd

  SHLD      EDX, EAX, CL
  JMP       @Shift

  { Shift is above 32. }
@Above32:
  AND       ECX, $1F

  DEC       CL
  SHLD      EDX, EAX, CL
  INC       CL

  { Main shifting. }
@Shift:
  SHL       EAX, CL
  PUSH      ECX
  PUSH      EAX
  MOV       EAX, DWORD PTR [Value + 4]
  SHR       EAX, 2
  XOR       CL, 31
  SHR       EAX, CL
  POP       ECX
  OR        EAX, ECX
  POP       ECX
  JMP       @SetCarry

  { Shift is equal to 32, no shifting required, only swap Hi and Lo dwords. }
@Exactly32:
  SHR       EDX, 1
  XCHG      EAX, EDX

  { Write passed carry bit to the result. }
@SetCarry:
  DEC       ECX
  CMP       BYTE PTR [EBX], 0
  JE        @ResetBit

  BTS       EAX, ECX
  JMP       @Swap

@ResetBit:
  BTR       EAX, ECX

  { Swap Hi and Lo dwords for shift > 32. }
@Swap:
  CMP       BYTE PTR [TempShift], 32
  JBE       @GetCarry
  XCHG      EAX, EDX

  { Get carry bit that will be output in CF parameter. }
@GetCarry:
  MOV       CL, BYTE PTR [TempShift]
  AND       ECX, $3F
  CMP       CL, 32
  JBE       @FromHigh

  AND       CL, $1F
  DEC       CL
  XOR       CL, 31
  BT        DWORD PTR [Value], ECX
  JMP       @StoreCarry

@FromHigh:
  DEC       CL
  XOR       CL, 31
  BT        DWORD PTR [Value + 4], ECX

@StoreCarry:
  SETC      CL
  MOV       BYTE PTR [EBX], CL

  { Restore EBX register. }
@FuncEnd:
  POP       EBX
end;
 {$ENDIF ~x64}
{$ELSE}
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
{$ENDIF ~PurePascal}

function RCL(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8;
begin
  Result := RCLCarry(Value, Shift, CF);
end;

function RCL(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16;
begin
  Result := RCLCarry(Value, Shift, CF);
end;

function RCL(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32;
begin
  Result := RCLCarry(Value, Shift, CF);
end;

function RCL(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64;
begin
  Result := RCLCarry(Value, Shift, CF);
end;

procedure RCLValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

procedure RCLValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

procedure RCLValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

procedure RCLValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCLCarry(Value, Shift, CF);
end;

procedure RCLValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;

procedure RCLValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;

procedure RCLValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;

procedure RCLValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCL(Value, Shift, CF);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Rotate right with carry (RCR)'}{$ENDIF}
function RCRCarry(Value: UInt8; Shift: UInt8; var CF: ByteBool): UInt8;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AL, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCR       AL, CL
  SETC      BYTE PTR [CF]
 {$ELSE}
  XCHG      EDX, ECX
  SHR       BYTE PTR [EDX], 1
  RCR       AL, CL
  SETC      BYTE PTR [EDX]
 {$ENDIF ~x64}
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function RCRCarry(Value: UInt16; Shift: UInt8; var CF: ByteBool): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCR       AX, CL
  SETC      BYTE PTR [CF]
 {$ELSE}
  XCHG      EDX, ECX
  SHR       BYTE PTR [EDX], 1
  RCR       AX, CL
  SETC      BYTE PTR [EDX]
 {$ENDIF ~x64}
end;
{$ELSE}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $0F;
  Carry := CF;
  Result := Value;

  For I := 1 to Shift do
  begin
    CF := (Result and 1) <> 0;
    Result := UInt16((Result shr 1) or ((UInt16(Carry) and UInt16(1)) shl 15));
    Carry := CF;
  end;
end;
{$ENDIF ~PurePascal}

function RCRCarry(Value: UInt32; Shift: UInt8; var CF: ByteBool): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCR       EAX, CL
  SETC      BYTE PTR [CF]
 {$ELSE}
  XCHG      EDX, ECX
  SHR       BYTE PTR [EDX], 1
  RCR       EAX, CL
  SETC      BYTE PTR [EDX]
 {$ENDIF ~x64}
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function RCRCarry(Value: UInt64; Shift: UInt8; var CF: ByteBool): UInt64;
{$IFNDEF PurePascal} register; assembler;
 {$IFDEF x64}
asm
  MOV       RAX, Value
  MOV       CL, Shift
  SHR       BYTE PTR [CF], 1
  RCR       RAX, CL
  SETC      BYTE PTR [CF]
end;
 {$ELSE}
var
  TempShift: UInt32;
asm
  PUSH      EBX

  AND       EAX, $3F
  MOV       DWORD PTR [TempShift], EAX
  MOV       ECX, EAX
  MOV       EBX, EDX

  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]
  CMP       ECX, 32

  JE        @Exactly32
  JA        @Above32

  { Shift is below 32. }
  TEST      ECX, ECX
  JZ        @FuncEnd

  SHRD      EAX, EDX, CL
  JMP       @Shift

  { Shift is above 32. }
@Above32:
  AND       ECX, $1F

  DEC       CL
  SHRD      EAX, EDX, CL
  INC       CL

  { Main shifting. }
@Shift:
  SHR       EDX, CL
  PUSH      ECX
  PUSH      EDX
  MOV       EDX, DWORD PTR [Value]
  SHL       EDX, 2
  XOR       CL, 31
  SHL       EDX, CL
  POP       ECX
  OR        EDX, ECX
  POP       ECX
  JMP       @SetCarry

  { Shift is equal to 32, no shifting required, only swap Hi and Lo dwords. }
@Exactly32:
  SHL       EAX, 1
  XCHG      EAX, EDX

  { Write passed carry bit to the result. }
@SetCarry:
  DEC       ECX
  XOR       ECX, 31
  CMP       BYTE PTR [EBX], 0
  JE        @ResetBit

  BTS       EDX, ECX
  JMP       @Swap

@ResetBit:
  BTR       EDX, ECX

  { Swap Hi and Lo dwords for shift > 32. }
@Swap:
  CMP       BYTE PTR [TempShift], 32
  JBE       @GetCarry
  XCHG      EAX, EDX

  { Get carry bit that will be output in CF parameter. }
@GetCarry:
  MOV       CL, BYTE PTR [TempShift]
  AND       ECX, $3F
  CMP       CL, 32
  JA        @FromHigh

  DEC       CL
  BT        DWORD PTR [Value], ECX
  JMP       @StoreCarry

@FromHigh:
  AND       CL, $1F
  DEC       CL
  BT        DWORD PTR [Value + 4], ECX

@StoreCarry:
  SETC      CL
  MOV       BYTE PTR [EBX], CL

  { Restore EBX register. }
@FuncEnd:
  POP       EBX
end;
 {$ENDIF ~x64}
{$ELSE}
var
  I: Integer;
  Carry: Boolean;
begin
  Shift := Shift and $3F;
  Carry := CF;
  Result := Value;

  for i := 1 to Shift do
  begin
    CF := (Result and 1) <> 0;
    Result := UInt64((Result shr 1) or ((UInt64(Carry) and 1) shl 63));
    Carry := CF;
  end;
end;
{$ENDIF ~PurePascal}

function RCR(Value: UInt8; Shift: UInt8; CF: ByteBool = False): UInt8;
begin
  Result := RCRCarry(Value, Shift, CF);
end;

function RCR(Value: UInt16; Shift: UInt8; CF: ByteBool = False): UInt16;
begin
  Result := RCRCarry(Value, Shift, CF);
end;

function RCR(Value: UInt32; Shift: UInt8; CF: ByteBool = False): UInt32;
begin
  Result := RCRCarry(Value, Shift, CF);
end;

function RCR(Value: UInt64; Shift: UInt8; CF: ByteBool = False): UInt64;
begin
  Result := RCRCarry(Value, Shift, CF);
end;

procedure RCRValueCarry(var Value: UInt8; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

procedure RCRValueCarry(var Value: UInt16; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

procedure RCRValueCarry(var Value: UInt32; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

procedure RCRValueCarry(var Value: UInt64; Shift: UInt8; var CF: ByteBool);
begin
  Value := RCRCarry(Value, Shift, CF);
end;

procedure RCRValue(var Value: UInt8; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;

procedure RCRValue(var Value: UInt16; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;

procedure RCRValue(var Value: UInt32; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;

procedure RCRValue(var Value: UInt64; Shift: UInt8; CF: ByteBool = False);
begin
  Value := RCR(Value, Shift, CF);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic left shift (SAL)'}{$ENDIF}
function SAL(Value: UInt8; Shift: UInt8): UInt8;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AL, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  SAL       AL, CL
end;
{$ELSE}
begin
  Result := UInt8(Value shl Shift);
end;
{$ENDIF ~PurePascal}

function SAL(Value: UInt16; Shift: UInt8): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  SAL       AX, CL
end;
{$ELSE}
begin
  Result := UInt16(Value shl Shift);
end;
{$ENDIF ~PurePascal}

function SAL(Value: UInt32; Shift: UInt8): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  SAL       EAX, CL
end;
{$ELSE}
begin
  Result := UInt32(Value shl Shift);
end;
{$ENDIF ~PurePascal}

function SAL(Value: UInt64; Shift: UInt8): UInt64;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  MOV       CL, Shift
  SAL       RAX, CL
 {$ELSE}
  MOV       ECX, EAX
  AND       ECX, $3F

  CMP       ECX, 31
  JA        @Above31

  { Shift is below 32. }
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]

  TEST      ECX, ECX
  JZ        @FuncEnd

  SHLD      EDX, EAX, CL
  SHL       EAX, CL
  JMP       @FuncEnd

  { Shift is above 31. }
@Above31:
  XOR       EAX, EAX
  MOV       EDX, DWORD PTR [Value]
  AND       ECX, $1F
  SHL       EDX, CL

  { End of the function. }
@FuncEnd:
 {$ENDIF ~x64}
end;
{$ELSE}
begin
  Result := UInt64(Value shl Shift);
end;
{$ENDIF ~PurePascal}

procedure SALValue(var Value: UInt8; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;

procedure SALValue(var Value: UInt16; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;

procedure SALValue(var Value: UInt32; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;

procedure SALValue(var Value: UInt64; Shift: UInt8);
begin
  Value := SAL(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Arithmetic right shift (SAR)'}{$ENDIF}
function SAR(Value: UInt8; Shift: UInt8): UInt8;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AL, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  SAR       AL, CL
end;
{$ELSE}
begin
  Shift := Shift and $07;
  if ((Value shr 7) <> 0) then
    Result := UInt8((Value shr Shift) or (UInt8($FF) shl (8 - Shift)))
  else
    Result := UInt8(Value shr Shift);
end;
{$ENDIF ~PurePascal}

function SAR(Value: UInt16; Shift: UInt8): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  SAR       AX, CL
end;
{$ELSE}
begin
  Shift := Shift and $0F;
  if ((Value shr 15) <> 0) then
    Result := UInt16((Value shr Shift) or (UInt16($FFFF) shl (16 - Shift)))
  else
    Result := UInt16(Value shr Shift);
end;
{$ENDIF ~PurePascal}

function SAR(Value: UInt32; Shift: UInt8): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
  MOV       CL, Shift
  SAR       EAX, CL
end;
{$ELSE}
begin
  Shift := Shift and $1F;
  if ((Value shr 31) <> 0) then
    Result := UInt32((Value shr Shift) or (UInt32($FFFFFFFF) shl (32 - Shift)))
  else
    Result := UInt32(Value shr Shift);
end;
{$ENDIF ~PurePascal}

function SAR(Value: UInt64; Shift: UInt8): UInt64;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  MOV       CL, Shift
  SAR       RAX, CL
 {$ELSE}
  MOV       ECX, EAX
  AND       ECX, $3F

  CMP       ECX, 31
  JA        @Above31

  { Shift is below 32. }
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]

  TEST      ECX, ECX
  JZ        @FuncEnd

  SHRD      EAX, EDX, CL
  SAR       EDX, CL
  JMP       @FuncEnd

  { Shift is above 31. }
@Above31:
  MOV       EAX, DWORD PTR [Value + 4]
  BT        EAX, 31
  JC        @BitSet

  XOR       EDX, EDX
  JMP       @DoShift

@BitSet:
  MOV       EDX, $FFFFFFFF

@DoShift:
  AND       ECX, $1F
  SAR       EAX, CL

  { End of the function. }
@FuncEnd:
 {$ENDIF ~x64}
end;
{$ELSE}
begin
  Shift := Shift and $3F;
  if ((Value shr 63) <> 0) then
    Result :=
      UInt64((Value shr Shift) or (UInt64($FFFFFFFFFFFFFFFF) shl (64 - Shift)))
  else
    Result := UInt64(Value shr Shift);
end;
{$ENDIF ~PurePascal}

procedure SARValue(var Value: UInt8; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;

procedure SARValue(var Value: UInt16; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;

procedure SARValue(var Value: UInt32; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;

procedure SARValue(var Value: UInt64; Shift: UInt8);
begin
  Value := SAR(Value, Shift);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Endianity swap'}{$ENDIF}
function EndianSwap(Value: UInt16): UInt16;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       AX, Value
 {$ENDIF ~x64}
  XCHG      AL, AH
end;
{$ELSE}
begin
  Result := UInt16((Value shl 8) or (Value shr 8));
end;
{$ENDIF ~PurePascal}

function EndianSwap(Value: UInt32): UInt32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
  BSWAP     EAX
end;
{$ELSE}
begin
  Result := UInt32(((Value and $000000FF) shl 24) or
                   ((Value and $0000FF00) shl 8) or
                   ((Value and $00FF0000) shr 8) or
                   ((Value and $FF000000) shr 24));
end;
{$ENDIF ~PurePascal}

function EndianSwap(Value: UInt64): UInt64;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  BSWAP     RAX
 {$ELSE}
  MOV       EAX, DWORD PTR [Value + 4]
  MOV       EDX, DWORD PTR [Value]
  BSWAP     EAX
  BSWAP     EDX
 {$ENDIF ~x64}
end;
{$ELSE}
begin
  Int64Rec(Result).Hi := EndianSwap(Int64Rec(Value).Lo);
  Int64Rec(Result).Lo := EndianSwap(Int64Rec(Value).Hi);
end;
{$ENDIF ~PurePascal}

procedure EndianSwapValue(var Value: UInt16);
begin
  Value := EndianSwap(Value);
end;

procedure EndianSwapValue(var Value: UInt32);
begin
  Value := EndianSwap(Value);
end;

procedure EndianSwapValue(var Value: UInt64);
begin
  Value := EndianSwap(Value);
end;

procedure EndianSwap(var Buffer; Size: TMemSize);
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  XCHG      RCX, RDX
  {$ELSE}
  MOV       RDX, RDI
  MOV       RCX, RSI
  {$ENDIF ~Windows}

  CMP       RCX, 1
  JBE       @RoutineEnd

  LEA       RAX, [RDX + RCX - 1]
  SHR       RCX, 1

@LoopStart:
  MOV       R8B, BYTE PTR [RDX]
  MOV       R9B, BYTE PTR [RAX]
  MOV       BYTE PTR [RAX], R8B
  MOV       BYTE PTR [RDX], R9B
  INC       RDX
  DEC       RAX

  DEC       RCX
  JNZ       @LoopStart

@RoutineEnd:
 {$ELSE}
  MOV       ECX, EDX
  CMP       ECX, 1
  JBE       @RoutineEnd

  PUSH      ESI
  PUSH      EDI

  MOV       ESI, EAX
  LEA       EDI, [EAX + ECX - 1]
  SHR       ECX, 1

@LoopStart:
  MOV       AL, BYTE PTR [ESI]
  MOV       DL, BYTE PTR [EDI]
  MOV       BYTE PTR [EDI], AL
  MOV       BYTE PTR [ESI], DL
  INC       ESI
  DEC       EDI

  DEC       ECX
  JNZ       @LoopStart

  POP       EDI
  POP       ESI

@RoutineEnd:
 {$ENDIF ~x64}
end;
{$ELSE}
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
      ByteBuff := PByte(PtrUInt(Addr(Buffer)) + I)^;
      PByte(PtrUInt(Addr(Buffer)) + I)^ :=
        PByte(PtrUInt(Addr(Buffer)) + (Size - I - 1))^;
      PByte(PtrUInt(Addr(Buffer)) + (Size - I - 1))^ := ByteBuff;
    end;
  end;
end;
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test (BT)'}{$ENDIF}
function BT(Value: UInt8; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $7
  BT        CX, DX
  {$ELSE}
  AND       SI, $7
  BT        DI, SI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       DX, $7
  BT        AX, DX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF ~PurePascal}

function BT(Value: UInt16; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BT        CX, DX
  {$ELSE}
  BT        DI, SI
  {$ENDIF ~Windows}
 {$ELSE}
  BT        AX, DX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF ~PurePascal}

function BT(Value: UInt32; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BT        ECX, EDX
  {$ELSE}
  BT        EDI, ESI
  {$ENDIF ~Windows}
 {$ELSE}
  BT        EAX, EDX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF ~PurePascal}

function BT(Value: UInt64; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BT        RCX, RDX
  {$ELSE}
  BT        RDI, RSI
  {$ENDIF ~Windows}
 {$ELSE}
  CMP       EAX, 32
  JAE       @TestHigh

  BT        DWORD PTR [Value], EAX
  JMP       @SetResult

@TestHigh:
  AND       EAX, $1F
  BT        DWORD PTR [Value + 4], EAX
 {$ENDIF ~x64}

@SetResult:
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
end;
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set (BTS)'}{$ENDIF}
function BTS(var Value: UInt8; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $7
  MOVZX     RAX, BYTE PTR [RCX]
  BTS       AX, DX
  MOV       BYTE PTR [RCX], AL
  {$ELSE}
  AND       SI, $7
  MOVZX     RAX, BYTE PTR [RDI]
  BTS       AX, SI
  MOV       BYTE PTR [RDI], AL
  {$ENDIF ~Windows}
{$ELSE}
  AND       DX, $7
  MOVZX     ECX, BYTE PTR [EAX]
  BTS       CX, DX
  MOV       BYTE PTR [EAX], CL
{$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt8(Value or (UInt8(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTS(var Value: UInt16; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $FF
  BTS       WORD PTR [RCX], DX
  {$ELSE}
  AND       SI, $FF
  BTS       WORD PTR [RDI], SI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       DX, $FF
  BTS       WORD PTR [EAX], DX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt16(Value or (UInt16(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTS(var Value: UInt32; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       EDX, $FF
  BTS       DWORD PTR [RCX],  EDX
  {$ELSE}
  AND       ESI, $FF
  BTS       DWORD PTR [RDI],  ESI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EDX, $FF
  BTS       DWORD PTR [EAX],  EDX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt32(Value or (UInt32(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTS(var Value: UInt64; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RDX, $FF
  BTS       QWORD PTR [RCX], RDX
  {$ELSE}
  AND       RSI, $FF
  BTS       DWORD PTR [RDI], RSI
  {$ENDIF ~Windows}
 {$ELSE}
  CMP       EDX, 32
  JAE       @TestHigh

  BTS       DWORD PTR [Value], EDX
  JMP       @SetResult

@TestHigh:
  AND       EDX, $1F
  BTS       DWORD PTR [EAX + 4], EDX
 {$ENDIF ~x64}
@SetResult:
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt64(Value or (UInt64(1) shl Bit));
end;
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and reset (BTR)'}{$ENDIF}
function BTR(var Value: UInt8; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $7
  MOVZX     RAX, BYTE PTR [RCX]
  BTR       AX, DX
  MOV       BYTE PTR [RCX], AL
  {$ELSE}
  AND       SI, $7
  MOVZX     RAX, BYTE PTR [RDI]
  BTR       AX, SI
  MOV       BYTE PTR [RDI], AL
  {$ENDIF ~Windows}
 {$ELSE}
  AND       DX, $7
  MOVZX     ECX, BYTE PTR [EAX]
  BTR       CX, DX
  MOV       BYTE PTR [EAX], CL
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt8(Value and not (UInt8(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTR(var Value: UInt16; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $FF
  BTR       WORD PTR [RCX], DX
  {$ELSE}
  AND       SI, $FF
  BTR       WORD PTR [RDI], SI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       DX, $FF
  BTR       WORD PTR [EAX], DX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt16(Value and not (UInt16(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTR(var Value: UInt32; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       EDX, $FF
  BTR       DWORD PTR [RCX], EDX
  {$ELSE}
  AND       ESI, $FF
  BTR       DWORD PTR [RDI], ESI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EDX, $FF
  BTR       DWORD PTR [EAX], EDX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt32(Value and not(UInt32(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTR(var Value: UInt64; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RDX, $FF
  BTR       QWORD PTR [RCX], RDX
  {$ELSE}
  AND       RSI, $FF
  BTR       DWORD PTR [RDI], RSI
  {$ENDIF ~Windows}
 {$ELSE}
  CMP       EDX, 32
  JAE       @TestHigh

  BTR       DWORD PTR [Value], EDX
  JMP       @SetResult

@TestHigh:
  AND       EDX, $1F
  BTR       DWORD PTR [EAX + 4], EDX
 {$ENDIF ~x64}

@SetResult:
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt64(Value and not (UInt64(1) shl Bit));
end;
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and complement (BTC)'}{$ENDIF}
function BTC(var Value: UInt8; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $7
  MOVZX     RAX, BYTE PTR [RCX]
  BTC       AX, DX
  MOV       BYTE PTR [RCX], AL
  {$ELSE}
  AND       SI, $7
  MOVZX     RAX, BYTE PTR [RDI]
  BTC       AX, SI
  MOV       BYTE PTR [RDI], AL
  {$ENDIF ~Windows}
 {$ELSE}
  AND       DX, $7
  MOVZX     ECX, BYTE PTR [EAX]
  BTC       CX, DX
  MOV       BYTE PTR [EAX], CL
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt8(Value xor (UInt8(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTC(var Value: UInt16; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       DX, $FF
  BTC       WORD PTR [RCX], DX
  {$ELSE}
  AND       SI, $FF
  BTC       WORD PTR [RDI], SI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       DX, $FF
  BTC       WORD PTR [EAX], DX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt16(Value xor (UInt16(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTC(var Value: UInt32; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       EDX, $FF
  BTC       DWORD PTR [RCX], EDX
  {$ELSE}
  AND       ESI, $FF
  BTC       DWORD PTR [RDI], ESI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EDX, $FF
  BTC       DWORD PTR [EAX], EDX
 {$ENDIF ~x64}
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt32(Value xor (UInt32(1) shl Bit));
end;
{$ENDIF ~PurePascal}

function BTC(var Value: UInt64; Bit: UInt8): ByteBool;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RDX, $FF
  BTC       QWORD PTR [RCX], RDX
  {$ELSE}
  AND       RSI, $FF
  BTC       DWORD PTR [RDI], RSI
  {$ENDIF ~Windows}
 {$ELSE}
  CMP       EDX, 32
  JAE       @TestHigh

  BTC       DWORD PTR [Value], EDX
  JMP       @SetResult

@TestHigh:
  AND       EDX, $1F
  BTC       DWORD PTR [EAX + 4], EDX
 {$ENDIF ~x64}

@SetResult:
  SETC      AL
end;
{$ELSE}
begin
  Result := ((Value shr Bit) and 1) <> 0;
  Value := UInt64(Value xor (UInt64(1) shl Bit));
end;
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit test and set to a given value'}{$ENDIF}
function BitSetTo(var Value: UInt8; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;

function BitSetTo(var Value: UInt16; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;

function BitSetTo(var Value: UInt32; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;

function BitSetTo(var Value: UInt64; Bit: UInt8; NewValue: ByteBool): ByteBool;
begin
  if (NewValue) then
    Result := BTS(Value, Bit)
  else
    Result := BTR(Value, Bit);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan forward (BSF)'}{$ENDIF}
function BSF(Value: UInt8): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  XOR       RAX, RAX
  {$IFDEF Windows}
  AND       RCX, $FF
  BSF       AX, CX
  {$ELSE}
  AND       RDI, $FF
  BSF       AX, DI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FF
  BSF       AX, AX
 {$ENDIF ~x64}
  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function BSF(Value: UInt16): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  XOR       RAX, RAX
  {$IFDEF Windows}
  BSF       AX, CX
  {$ELSE}
  BSF       AX, DI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FFFF
  BSF       AX, AX
 {$ENDIF ~x64}
  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function BSF(Value: UInt32): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSF       EAX, ECX
  {$ELSE}
  BSF       EAX, EDI
  {$ENDIF ~Windows}
 {$ELSE}
  BSF       EAX, EAX
 {$ENDIF ~x64}
  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function BSF(Value: UInt64): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSF       RAX, RCX
  {$ELSE}
  BSF       RAX, RDI
  {$ENDIF ~Windows}

  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
 {$ELSE}
  BSF       EAX, DWORD PTR [Value]
  JNZ       @RoutineEnd

  BSF       EAX, DWORD PTR [Value + 4]
  JNZ       @Add32

  MOV       EAX, -33

@Add32:
  ADD       EAX, 32

@RoutineEnd:
 {$ENDIF ~x64}
end;
{$ELSE}
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
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Bit scan reversed (BSR)'}{$ENDIF}
function BSR(Value: UInt8): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  XOR       RAX, RAX
  {$IFDEF Windows}
  AND       RCX, $FF
  BSR       AX, CX
  {$ELSE}
  AND       RDI, $FF
  BSR       AX, DI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FF
  BSR       AX, AX
 {$ENDIF ~x64}
  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function BSR(Value: UInt16): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  XOR       RAX, RAX
  {$IFDEF Windows}
  BSR       AX, CX
  {$ELSE}
  BSR       AX, DI
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FFFF
  BSR       AX, AX
 {$ENDIF ~x64}
  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function BSR(Value: UInt32): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSR       EAX, ECX
  {$ELSE}
  BSR       EAX, EDI
  {$ENDIF ~Windows}
 {$ELSE}
  BSR       EAX, EAX
 {$ENDIF ~x64}
  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
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
{$ENDIF ~PurePascal}

function BSR(Value: UInt64): Int32;
{$IFNDEF PurePascal} register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  BSR       RAX, RCX
  {$ELSE}
  BSR       RAX, RDI
  {$ENDIF ~Windows}
 {$ELSE}
  BSR       EAX, DWORD PTR [Value + 4]
  JZ        @ScanLow

  ADD       EAX, 32
  JMP       @RoutineEnd

@ScanLow:
  BSR       EAX, DWORD PTR [Value]
 {$ENDIF ~x64}

  JNZ       @RoutineEnd
  MOV       EAX, -1

@RoutineEnd:
end;
{$ELSE}
var
  I: Integer;
begin
  Result := -1;
  for i := 63 downto 0 do
    if ((Value shr I) and 1 <> 0) then
    begin
      Result := I;
      Break;
    end;
end;
{$ENDIF ~PurePascal}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Population count'}{$ENDIF}
{$IFDEF BO_UseLookupTable}
const
  PopCountTable: array[UInt8] of UInt8 = (
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3,
    2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4,
    2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5,
    4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4,
    3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6,
    4, 5, 5, 6, 5, 6, 6, 7, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4,
    3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5,
    4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4, 5,
    3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6,
    5, 6, 6, 7, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);
{$ENDIF}

function Fce_PopCount_8_Pas(Value: UInt8): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
  Result := PopCountTable[Value];
end;
{$ELSE}
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
{$ENDIF ~BO_UseLookupTable}

function Fce_PopCount_16_Pas(Value: UInt16): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
  Result := PopCountTable[UInt8(Value)] + PopCountTable[UInt8(Value shr 8)];
end;
{$ELSE}
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
{$ENDIF ~BO_UseLookupTable}

function Fce_PopCount_32_Pas(Value: UInt32): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
  Result :=
    PopCountTable[UInt8(Value)] + PopCountTable[UInt8(Value shr 8)] +
    PopCountTable[UInt8(Value shr 16)] + PopCountTable[UInt8(Value shr 24)];
end;
{$ELSE}
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
{$ENDIF ~BO_UseLookupTable}

function Fce_PopCount_64_Pas(Value: UInt64): Int32; register;
{$IFDEF BO_UseLookupTable}
begin
 {$IFDEF 64bit}
  Result :=
    PopCountTable[UInt8(Value)] + PopCountTable[UInt8(Value shr 8)] +
    PopCountTable[UInt8(Value shr 16)] + PopCountTable[UInt8(Value shr 24)] +
    PopCountTable[UInt8(Value shr 32)] + PopCountTable[UInt8(Value shr 40)] +
    PopCountTable[UInt8(Value shr 48)] + PopCountTable[UInt8(Value shr 56)];
 {$ELSE}
  Result := PopCount(Int64Rec(Value).Lo) + PopCount(Int64Rec(Value).Hi);
 {$ENDIF ~64bit}
end;
{$ELSE}
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
{$ENDIF ~BO_UseLookupTable}

{$IFNDEF PurePascal}
function Fce_PopCount_8_Asm(Value: UInt8): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
 {$ELSE}
  AND       EAX, $FF
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $66, $F3, $0F, $B8, $C0   { POPCNT    AX, AX }
 {$ELSE}
  POPCNT    AX, AX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_PopCount_16_Asm(Value: UInt16): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
 {$ELSE}
  AND       EAX, $FFFF
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $66, $F3, $0F, $B8, $C0   { POPCNT    AX, AX }
 {$ELSE}
  POPCNT    AX, AX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_PopCount_32_Asm(Value: UInt32): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $B8, $C0   { POPCNT    EAX, EAX }
 {$ELSE}
  POPCNT    EAX, EAX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_PopCount_64_Asm(Value: UInt64): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value

  {$IFDEF ASM_MachineCode}
  DB        $F3, $48, $0F, $B8, $C0   { POPCNT    RAX, RAX }
  {$ELSE}
  POPCNT    RAX, RAX
  {$ENDIF ~ASM_MachineCode}
 {$ELSE}
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]

  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $B8, $C0        { POPCNT  EAX, EAX }
  DB        $F3, $0F, $B8, $D2        { POPCNT  EDX, EDX }
  {$ELSE}
  POPCNT    EAX, EAX
  POPCNT    EDX, EDX
  {$ENDIF ~ASM_MachineCode}

  ADD       EAX, EDX
 {$ENDIF ~x64}
end;
{$ENDIF ~PurePascal}

function PopCount(Value: UInt8): Int32;
begin
  Result := Var_PopCount_8(Value);
end;

function PopCount(Value: UInt16): Int32;
begin
  Result := Var_PopCount_16(Value);
end;

function PopCount(Value: UInt32): Int32;
begin
  Result := Var_PopCount_32(Value);
end;

function PopCount(Value: UInt64): Int32;
begin
  Result := Var_PopCount_64(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Nibble manipulation'}{$ENDIF}
function GetHighNibble(Value: UInt8): TNibble;
begin
  Result := (Value shr 4) and $0F;
end;

function GetLowNibble(Value: UInt8): TNibble;
begin
  Result := Value and $0F;
end;

function SetHighNibble(Value: UInt8; SetTo: TNibble): UInt8;
begin
  Result := (Value and $0F) or UInt8((SetTo and $0F) shl 4);
end;

function SetLowNibble(Value: UInt8; SetTo: TNibble): UInt8;
begin
  Result := (Value and $F0) or UInt8(SetTo and $0F);
end;

procedure SetHighNibbleValue(var Value: UInt8; SetTo: TNibble);
begin
  Value := SetHighNibble(Value,SetTo);
end;

procedure SetLowNibbleValue(var Value: UInt8; SetTo: TNibble);
begin
  Value := SetLowNibble(Value,SetTo);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Get flag state'}{$ENDIF}
function GetFlagState(Value, FlagBitmask: UInt8; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;

function GetFlagState(Value, FlagBitmask: UInt16; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;

function GetFlagState(Value, FlagBitmask: UInt32; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;

function GetFlagState(Value, FlagBitmask: UInt64; ExactMatch: Boolean = False): Boolean;
begin
  if (ExactMatch) then
    Result := (Value and FlagBitmask) = FlagBitmask
  else
    Result := (Value and FlagBitmask) <> 0;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag'}{$ENDIF}
function SetFlag(Value, FlagBitmask: UInt8): UInt8;
begin
  Result := Value or FlagBitmask;
end;

function SetFlag(Value, FlagBitmask: UInt16): UInt16;
begin
  Result := Value or FlagBitmask;
end;

function SetFlag(Value, FlagBitmask: UInt32): UInt32;
begin
  Result := Value or FlagBitmask;
end;

function SetFlag(Value, FlagBitmask: UInt64): UInt64;
begin
  Result := Value or FlagBitmask;
end;

procedure SetFlagValue(var Value: UInt8; FlagBitmask: UInt8);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

procedure SetFlagValue(var Value: UInt16; FlagBitmask: UInt16);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

procedure SetFlagValue(var Value: UInt32; FlagBitmask: UInt32);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

procedure SetFlagValue(var Value: UInt64; FlagBitmask: UInt64);
begin
  Value := SetFlag(Value, FlagBitmask);
end;

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

function SetFlags(Value: UInt8; Flags: array of UInt8): UInt8;
begin
  Result := SetFlags_8(Value, Flags);
end;

function SetFlags(Value: UInt16; Flags: array of UInt16): UInt16;
begin
  Result := SetFlags_16(Value, Flags);
end;

function SetFlags(Value: UInt32; Flags: array of UInt32): UInt32;
begin
  Result := SetFlags_32(Value, Flags);
end;

function SetFlags(Value: UInt64; Flags: array of UInt64): UInt64;
begin
  Result := SetFlags_64(Value, Flags);
end;

procedure SetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
begin
  Value := SetFlags_8(Value, Flags);
end;

procedure SetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
begin
  Value := SetFlags_16(Value, Flags);
end;

procedure SetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
begin
  Value := SetFlags_32(Value, Flags);
end;

procedure SetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);
begin
  Value := SetFlags_64(Value, Flags);
end;

procedure SetFlagsValue(var Value: UInt8; Flags: array of UInt8);
begin
  SetFlagsValue_8(Value, Flags);
end;

procedure SetFlagsValue(var Value: UInt16; Flags: array of UInt16);
begin
  SetFlagsValue_16(Value, Flags);
end;

procedure SetFlagsValue(var Value: UInt32; Flags: array of UInt32);
begin
  SetFlagsValue_32(Value, Flags);
end;

procedure SetFlagsValue(var Value: UInt64; Flags: array of UInt64);
begin
  SetFlagsValue_64(Value, Flags);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Reset flag'}{$ENDIF}
function ResetFlag(Value, FlagBitmask: UInt8): UInt8;
begin
  Result := Value and not FlagBitmask;
end;

function ResetFlag(Value, FlagBitmask: UInt16): UInt16;
begin
  Result := Value and not FlagBitmask;
end;

function ResetFlag(Value, FlagBitmask: UInt32): UInt32;
begin
  Result := Value and not FlagBitmask;
end;

function ResetFlag(Value, FlagBitmask: UInt64): UInt64;
begin
  Result := Value and not FlagBitmask;
end;

procedure ResetFlagValue(var Value: UInt8; FlagBitmask: UInt8);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

procedure ResetFlagValue(var Value: UInt16; FlagBitmask: UInt16);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

procedure ResetFlagValue(var Value: UInt32; FlagBitmask: UInt32);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

procedure ResetFlagValue(var Value: UInt64; FlagBitmask: UInt64);
begin
  Value := ResetFlag(Value, FlagBitmask);
end;

function ResetFlags_8(Value: UInt8; Flags: array of UInt8): UInt8;
var
  TempBitmask: UInt8;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := ResetFlag(Value, TempBitmask);
end;

function ResetFlags_16(Value: UInt16; Flags: array of UInt16): UInt16;
var
  TempBitmask: UInt16;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := ResetFlag(Value, TempBitmask);
end;

function ResetFlags_32(Value: UInt32; Flags: array of UInt32): UInt32;
var
  TempBitmask: UInt32;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := ResetFlag(Value, TempBitmask);
end;

function ResetFlags_64(Value: UInt64; Flags: array of UInt64): UInt64;
var
  TempBitmask: UInt64;
  I: Integer;
begin
  TempBitmask := 0;

  for I := Low(Flags) to High(flags) do
    TempBitmask := TempBitmask or Flags[i];

  Result := ResetFlag(Value, TempBitmask);
end;

function ResetFlags(Value: UInt8; Flags: array of UInt8): UInt8;
begin
  Result := ResetFlags_8(Value, Flags);
end;

function ResetFlags(Value: UInt16; Flags: array of UInt16): UInt16;
begin
  Result := ResetFlags_16(Value, Flags);
end;

function ResetFlags(Value: UInt32; Flags: array of UInt32): UInt32;
begin
  Result := ResetFlags_32(Value, Flags);
end;

function ResetFlags(Value: UInt64; Flags: array of UInt64): UInt64;
begin
  Result := ResetFlags_64(Value, Flags);
end;

procedure ResetFlagsValue_8(var Value: UInt8; Flags: array of UInt8);
begin
  Value := ResetFlags_8(Value, Flags);
end;

procedure ResetFlagsValue_16(var Value: UInt16; Flags: array of UInt16);
begin
  Value := ResetFlags_16(Value, Flags);
end;

procedure ResetFlagsValue_32(var Value: UInt32; Flags: array of UInt32);
begin
  Value := ResetFlags_32(Value, Flags);
end;

procedure ResetFlagsValue_64(var Value: UInt64; Flags: array of UInt64);
begin
  Value := ResetFlags_64(Value, Flags);
end;

procedure ResetFlagsValue(var Value: UInt8; Flags: array of UInt8);
begin
  ResetFlagsValue_8(Value, Flags);
end;

procedure ResetFlagsValue(var Value: UInt16; Flags: array of UInt16);
begin
  ResetFlagsValue_16(Value, Flags);
end;

procedure ResetFlagsValue(var Value: UInt32; Flags: array of UInt32);
begin
  ResetFlagsValue_32(Value, Flags);
end;

procedure ResetFlagsValue(var Value: UInt64; Flags: array of UInt64);
begin
  ResetFlagsValue_64(Value, Flags);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Set flag state'}{$ENDIF}
function SetFlagState(Value, FlagBitmask: UInt8; NewState: Boolean): UInt8;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

function SetFlagState(Value, FlagBitmask: UInt16; NewState: Boolean): UInt16;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

function SetFlagState(Value, FlagBitmask: UInt32; NewState: Boolean): UInt32;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

function SetFlagState(Value, FlagBitmask: UInt64; NewState: Boolean): UInt64;
begin
  if (NewState) then
    Result := SetFlag(Value, FlagBitmask)
  else
    Result := ResetFlag(Value, FlagBitmask);
end;

procedure SetFlagStateValue(var Value: UInt8; FlagBitmask: UInt8; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;

procedure SetFlagStateValue(var Value: UInt16; FlagBitmask: UInt16; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;

procedure SetFlagStateValue(var Value: UInt32; FlagBitmask: UInt32; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;

procedure SetFlagStateValue(var Value: UInt64; FlagBitmask: UInt64; NewState: Boolean);
begin
  Value := SetFlagState(Value, FlagBitmask, NewState);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Get bits'}{$ENDIF}
function GetBits(Value: UInt8; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt8;
begin
  Result := Value and UInt8(($FF shl (FromBit and 7)) and ($FF shr (7 - (ToBit and 7))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 7);
end;

function GetBits(
  Value: UInt16; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt16;
begin
  Result := Value and UInt16(($FFFF shl (FromBit and 15)) and ($FFFF shr (15 - (ToBit and 15))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 15);
end;

function GetBits(
  Value: UInt32; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt32;
begin
  Result := Value and UInt32(($FFFFFFFF shl (FromBit and 31)) and ($FFFFFFFF shr (31 - (ToBit and 31))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 31);
end;

function GetBits(Value: UInt64; FromBit, ToBit: Integer; ShiftDown: Boolean = True): UInt64;
begin
  Result := Value and UInt64( (UInt64($FFFFFFFFFFFFFFFF) shl (FromBit and 63)) and (UInt64($FFFFFFFFFFFFFFFF) shr (63 - (ToBit and 63))));

  if (ShiftDown) then
    Result := Result shr (FromBit and 63);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Set bits'}{$ENDIF}
function SetBits(Value, NewBits: UInt8; FromBit, ToBit: Integer): UInt8;
var
  Mask: UInt8;
begin
  Mask := UInt8(($FF shl (FromBit and 7)) and ($FF shr (7 - (ToBit and 7))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

function SetBits(Value, NewBits: UInt16; FromBit, ToBit: Integer): UInt16;
var
  Mask: UInt16;
begin
  Mask := UInt16(($FFFF shl (FromBit and 15)) and ($FFFF shr (15 - (ToBit and 15))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

function SetBits(Value, NewBits: UInt32; FromBit, ToBit: Integer): UInt32;
var
  Mask: UInt32;
begin
  Mask := UInt32(($FFFFFFFF shl (FromBit and 31)) and ($FFFFFFFF shr (31 - (ToBit and 31))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

function SetBits(Value, NewBits: UInt64; FromBit, ToBit: Integer): UInt64;
var
  Mask: UInt64;
begin
  Mask := UInt64((UInt64($FFFFFFFFFFFFFFFF) shl (FromBit and 63)) and (UInt64($FFFFFFFFFFFFFFFF) shr (63 - (ToBit and 63))));
  Result := (Value and not Mask) or (NewBits and Mask);
end;

procedure SetBitsValue(
  var Value: UInt8; NewBits: UInt8; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;

procedure SetBitsValue(
  var Value: UInt16; NewBits: UInt16; FromBit, ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;

procedure SetBitsValue(
  var Value: UInt32; NewBits: UInt32; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;

procedure SetBitsValue(
  var Value: UInt64; NewBits: UInt64; FromBit,ToBit: Integer);
begin
  Value := SetBits(Value, NewBits, FromBit, ToBit);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Reverse bits'}{$ENDIF}
const
  RevBitsTable: array[UInt8] of UInt8 = (
    $00, $80, $40, $C0, $20, $A0, $60, $E0, $10, $90,
    $50, $D0, $30, $B0, $70, $F0, $08, $88, $48, $C8,
    $28, $A8, $68, $E8, $18, $98, $58, $D8, $38, $B8,
    $78, $F8, $04, $84, $44, $C4, $24, $A4, $64, $E4,
    $14, $94, $54, $D4, $34, $B4, $74, $F4, $0C, $8C,
    $4C, $CC, $2C, $AC, $6C, $EC, $1C, $9C, $5C, $DC,
    $3C, $BC, $7C, $FC, $02, $82, $42, $C2, $22, $A2,
    $62, $E2, $12, $92, $52, $D2, $32, $B2, $72, $F2,
    $0A, $8A, $4A, $CA, $2A, $AA, $6A, $EA, $1A, $9A,
    $5A, $DA, $3A, $BA, $7A, $FA, $06, $86, $46, $C6,
    $26, $A6, $66, $E6, $16, $96, $56, $D6, $36, $B6,
    $76, $F6, $0E, $8E, $4E, $CE, $2E, $AE, $6E, $EE,
    $1E, $9E, $5E, $DE, $3E, $BE, $7E, $FE, $01, $81,
    $41, $C1, $21, $A1, $61, $E1, $11, $91, $51, $D1,
    $31, $B1, $71, $F1, $09, $89, $49, $C9, $29, $A9,
    $69, $E9, $19, $99, $59, $D9, $39, $B9, $79, $F9,
    $05, $85, $45, $C5, $25, $A5, $65, $E5, $15, $95,
    $55, $D5, $35, $B5, $75, $F5, $0D, $8D, $4D, $CD,
    $2D, $AD, $6D, $ED, $1D, $9D, $5D, $DD, $3D, $BD,
    $7D, $FD, $03, $83, $43, $C3, $23, $A3, $63, $E3,
    $13, $93, $53, $D3, $33, $B3, $73, $F3, $0B, $8B,
    $4B, $CB, $2B, $AB, $6B, $EB, $1B, $9B, $5B, $DB,
    $3B, $BB, $7B, $FB, $07, $87, $47, $C7, $27, $A7,
    $67, $E7, $17, $97, $57, $D7, $37, $B7, $77, $F7,
    $0F, $8F, $4F, $CF, $2F, $AF, $6F, $EF, $1F, $9F,
    $5F, $DF, $3F, $BF, $7F, $FF);

function ReverseBits(Value: UInt8): UInt8;
begin
  Result := UInt8(RevBitsTable[UInt8(Value)]);
end;

function ReverseBits(Value: UInt16): UInt16;
begin
  Result := UInt16((UInt16(RevBitsTable[UInt8(Value)]) shl 8) or UInt16(RevBitsTable[UInt8(Value shr 8)]));
end;

function ReverseBits(Value: UInt32): UInt32;
begin
  Result := UInt32((UInt32(RevBitsTable[UInt8(Value)]) shl 24) or
                   (UInt32(RevBitsTable[UInt8(Value shr 8)]) shl 16) or
                   (UInt32(RevBitsTable[UInt8(Value shr 16)]) shl 8) or
                    UInt32(RevBitsTable[UInt8(Value shr 24)]));
end;

function ReverseBits(Value: UInt64): UInt64;
begin
  Int64Rec(Result).Hi := ReverseBits(Int64Rec(Value).Lo);
  Int64Rec(Result).Lo := ReverseBits(Int64Rec(Value).Hi);
end;

procedure ReverseBitsValue(var Value: UInt8);
begin
  Value := ReverseBits(Value);
end;

procedure ReverseBitsValue(var Value: UInt16);
begin
  Value := ReverseBits(Value);
end;

procedure ReverseBitsValue(var Value: UInt32);
begin
  Value := ReverseBits(Value);
end;

procedure ReverseBitsValue(var Value: UInt64);
begin
  Value := ReverseBits(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Leading zero count'}{$ENDIF}
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

{$IFNDEF PurePascal}
function Fce_LZCount_8_Asm(Value: UInt8): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
 {$ELSE}
  AND       EAX, $FF
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $66, $F3, $0F, $BD, $C0   { LZCNT     AX, AX }
 {$ELSE}
  LZCNT     AX, AX
  SUB       AX, 8
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_LZCount_16_Asm(Value: UInt16): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
 {$ELSE}
  AND       EAX, $FFFF
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $66, $F3, $0F, $BD, $C0   { LZCNT     AX, AX }
 {$ELSE}
  LZCNT     AX, AX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_LZCount_32_Asm(Value: UInt32): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $BD, $C0       { LZCNT     EAX, EAX }
 {$ELSE}
  LZCNT     EAX, EAX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_LZCount_64_Asm(Value: UInt64): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  {$IFDEF ASM_MachineCode}
  DB        $F3, $48, $0F, $BD, $C0   { LZCNT     RAX, RAX }
  {$ELSE}
  LZCNT     RAX, RAX
  {$ENDIF ~ASM_MachineCode}
 {$ELSE}
  MOV       EAX, DWORD PTR [Value + 4]
  TEST      EAX,  EAX
  JZ        @ScanLow

  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $BD, $C0       { LZCNT      EAX, EAX }
  {$ELSE}
  LZCNT     EAX, EAX
  {$ENDIF ~ASM_MachineCode}
  JMP       @RoutineEnd

@ScanLow:
  MOV       EAX, DWORD PTR [Value]
  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $BD, $C0       { LZCNT      EAX, EAX }
  {$ELSE}
  LZCNT     EAX, EAX
  {$ENDIF ~ASM_MachineCode}
  ADD       EAX, 32

@RoutineEnd:
 {$ENDIF ~x64}
end;
{$ENDIF ~PurePascal}

function LZCount(Value: UInt8): Int32;
begin
  Result := Var_LZCount_8(Value);
end;

function LZCount(Value: UInt16): Int32;
begin
  Result := Var_LZCount_16(Value);
end;

function LZCount(Value: UInt32): Int32;
begin
  Result := Var_LZCount_32(Value);
end;

function LZCount(Value: UInt64): Int32;
begin
  Result := Var_LZCount_64(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Trailing zero count'}{$ENDIF}
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

{$IFNDEF PurePascal}
function Fce_TZCount_8_Asm(Value: UInt8): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
 {$ELSE}
  AND       EAX, $FF
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $66, $F3, $0F, $BC, $C0   { TZCNT     AX, AX }
 {$ELSE}
  MOV       AH, $FF
  TZCNT     AX, AX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_TZCount_16_Asm(Value: UInt16): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
 {$ELSE}
  AND       EAX, $FFFF
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $66, $F3, $0F, $BC, $C0   { TZCNT     AX, AX }
 {$ELSE}
  TZCNT     AX, AX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_TZCount_32_Asm(Value: UInt32): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $BC, $C0       { TZCNT     EAX, EAX }
 {$ELSE}
  TZCNT     EAX, EAX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_TZCount_64_Asm(Value: UInt64): Int32; register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value
  {$IFDEF ASM_MachineCode}
  DB        $F3, $48, $0F, $BC, $C0   { TZCNT     RAX, RAX }
  {$ELSE}
  TZCNT     RAX, RAX
  {$ENDIF ~ASM_MachineCode}
 {$ELSE}
  MOV       EAX, DWORD PTR [Value]
  TEST      EAX, EAX
  JZ        @ScanHigh

  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $BC, $C0       { TZCNT     EAX, EAX }
  {$ELSE}
  TZCNT     EAX, EAX
  {$ENDIF ~ASM_MachineCode}
  JMP       @RoutineEnd

@ScanHigh:
  MOV       EAX, DWORD PTR [Value + 4]
  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $BC, $C0       { TZCNT     EAX, EAX }
  {$ELSE}
  TZCNT     EAX, EAX
  {$ENDIF ~ASM_MachineCode}
  ADD       EAX, 32

@RoutineEnd:
 {$ENDIF ~x64}
end;
{$ENDIF ~PurePascal}

function TZCount(Value: UInt8): Int32;
begin
  Result := Var_TZCount_8(Value);
end;

function TZCount(Value: UInt16): Int32;
begin
  Result := Var_TZCount_16(Value);
end;

function TZCount(Value: UInt32): Int32;
begin
  Result := Var_TZCount_32(Value);
end;

function TZCount(Value: UInt64): Int32;
begin
  Result := Var_TZCount_64(Value);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Extract bits'}{$ENDIF}
{$IFDEF OverflowChecks}{$Q-}{$ENDIF}
function Fce_ExtractBits_8_Pas(
  Value: UInt8; Start, Length: UInt8): UInt8; register;
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

function Fce_ExtractBits_16_Pas(
  Value: UInt16; Start, Length: UInt8): UInt16; register;
begin
  if (Start <= 15) then
  begin
    if (Length <= 15) then
      Result :=
        UInt16(Value shr Start) and UInt16(Int16(UInt16(1) shl Length) - 1)
    else
      Result := UInt16(Value shr Start) and UInt16(-1);
  end else
    Result := 0;
end;

function Fce_ExtractBits_32_Pas(
  Value: UInt32; Start, Length: UInt8): UInt32; register;
begin
  if (Start <= 31) then
  begin
    if (Length <= 31) then
      Result :=
        UInt32(Value shr Start) and UInt32(Int32(UInt32(1) shl Length) - 1)
    else
      Result := UInt32(Value shr Start) and UInt32(-1);
  end else
    Result := 0;
end;

function Fce_ExtractBits_64_Pas(
  Value: UInt64; Start, Length: UInt8): UInt64; register;
begin
  if (Start <= 63) then
  begin
    if (Length <= 63) then
      Result :=
        UInt64(Value shr Start) and UInt64(Int64(UInt64(1) shl Length) - 1)
    else
      Result := UInt64(Value shr Start) and UInt64(-1);
  end else
    Result := 0;
end;

{$IFDEF OverflowChecks}{$Q+}{$ENDIF}

{$IFNDEF PurePascal}
function Fce_ExtractBits_8_Asm(
  Value: UInt8; Start, Length: UInt8): UInt8; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value

  {$IFDEF Windows}
  SHL       R8, 8
  AND       RDX, $FF
  OR        RDX, R8
  {$ELSE}
  SHL       RDX, 8
  MOV       DL, SIL
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FF
  MOV       DH, CL
 {$ENDIF ~x64}

 {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $68, $F7, $C0   { BEXTR     EAX, EAX, EDX }
 {$ELSE}
  BEXTR     EAX, EAX, EDX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_ExtractBits_16_Asm(
  Value: UInt16; Start, Length: UInt8): UInt16; register; assembler;
asm
 {$IFDEF x64}
  MOVZX     RAX, Value
  {$IFDEF Windows}
  SHL       R8, 8
  AND       RDX, $FF
  OR        RDX, R8
  {$ELSE}
  SHL       RDX, 8
  MOV       DL, SIL
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FFFF
  MOV       DH, CL
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $68, $F7, $C0   { BEXTR     EAX, EAX, EDX }
 {$ELSE}
  BEXTR     EAX, EAX, EDX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_ExtractBits_32_Asm(
  Value: UInt32; Start, Length: UInt8): UInt32; register; assembler;
asm
 {$IFDEF x64}
  MOV       EAX, Value
  {$IFDEF Windows}
  SHL       R8, 8
  AND       RDX, $FF
  OR        RDX, R8
  {$ELSE}
  SHL       RDX, 8
  MOV       DL, SIL
  {$ENDIF ~Windows}
 {$ELSE}
  MOV       DH, CL
 {$ENDIF ~x64}
 {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $68, $F7, $C0   { BEXTR     EAX, EAX, EDX }
 {$ELSE}
  BEXTR     EAX, EAX, EDX
 {$ENDIF ~ASM_MachineCode}
end;

function Fce_ExtractBits_64_Asm(
  Value: UInt64; Start, Length: UInt8): UInt64; register; assembler;
asm
 {$IFDEF x64}
  MOV       RAX, Value

  {$IFDEF Windows}
  SHL       R8, 8
  AND       RDX, $FF
  OR        RDX, R8
  {$ELSE}
  SHL       RDX, 8
  MOV       DL, SIL
  {$ENDIF ~Windows}

  {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $E8, $F7, $C0   { BEXTR     RAX, RAX, RDX }
  {$ELSE}
  BEXTR     RAX, RAX, RDX
  {$ENDIF ~ASM_MachineCode}
 {$ELSE}
  MOV       CL, AL
  MOV       CH, DL

  AND       EAX, $FF
  AND       EDX, $FF
  ADD       EAX, EDX

  XOR       EDX, EDX

  CMP       CL, 31
  JA        @AllHigh

  CMP       EAX, 32
  JBE       @AllLow

  { Extraction is done across low and high DWORDs boundary. }
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]

  { Extract from low DWORD. }
  {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $70, $F7, $C0        { BEXTR     EAX, EAX, ECX }
  {$ELSE}
  BEXTR     EAX, EAX, ECX
  {$ENDIF ~ASM_MachineCode}

  { Extract form high DWORD. }
  PUSH      ECX
  ADD       CH, CL
  SUB       CH, 32
  XOR       CL, CL

  {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $70, $F7, $D2        { BEXTR     EDX, EDX, ECX }
  {$ELSE}
  BEXTR     EDX, EDX, ECX
  {$ENDIF ~ASM_MachineCode}

  { Combine results. }
  POP       ECX
  PUSH      EBX

  XOR       EBX, EBX
  SHRD      EBX, EDX, CL
  SHR       EDX, CL
  OR        EAX, EBX

  POP       EBX
  JMP       @RoutineEnd

  { Extraction is done only from low DWORD. }
@AllLow:
  MOV       EAX, DWORD PTR [Value]
  {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $70, $F7, $C0        { BEXTR     EAX, EAX, ECX }
  {$ELSE}
  BEXTR     EAX, EAX, ECX
  {$ENDIF ~ASM_MachineCode}
  JMP       @RoutineEnd

  { Extraction is done only from high DWORD. }
@AllHigh:
  SUB       CL, 32
  MOV       EAX, DWORD PTR [Value + 4]
  {$IFDEF ASM_MachineCode}
  DB        $C4, $E2, $70, $F7, $C0        { BEXTR     EAX, EAX, ECX }
  {$ELSE}
  BEXTR     EAX, EAX, ECX
  {$ENDIF ~ASM_MachineCode}

@RoutineEnd:
 {$ENDIF ~x64}
end;
{$ENDIF ~PurePascal}

function ExtractBits(Value: UInt8; Start, Length: UInt8): UInt8;
begin
  Result := Var_ExtractBits_8(Value, Start, Length);
end;

function ExtractBits(Value: UInt16; Start, Length: UInt8): UInt16;
begin
  Result := Var_ExtractBits_16(Value, Start, Length);
end;

function ExtractBits(Value: UInt32; Start, Length: UInt8): UInt32;
begin
  Result := Var_ExtractBits_32(Value, Start, Length);
end;

function ExtractBits(Value: UInt64; Start, Length: UInt8): UInt64;
begin
  Result := Var_ExtractBits_64(Value, Start, Length);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits extract'}{$ENDIF}
function Fce_ParallelBitsExtract_8_Pas(Value, Mask: UInt8): UInt8; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 7 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt8(Result shl 1) or UInt8((Value shr I) and 1);
end;

function Fce_ParallelBitsExtract_16_Pas(Value, Mask: UInt16): UInt16; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 15 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt16(Result shl 1) or UInt16((Value shr I) and 1);
end;

function Fce_ParallelBitsExtract_32_Pas(Value, Mask: UInt32): UInt32; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 31 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt32(Result shl 1) or UInt32((Value shr I) and 1);
end;

function Fce_ParallelBitsExtract_64_Pas(Value, Mask: UInt64): UInt64; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 63 downto 0 do
    if (((Mask shr I) and 1) <> 0) then
      Result := UInt64(Result shl 1) or UInt64((Value shr I) and 1);
end;

{$IFNDEF PurePascal}
function Fce_ParallelBitsExtract_8_Asm(Value, Mask: UInt8): UInt8; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RCX, $FF
  AND       RDX, $FF
  DB        $C4, $E2, $72, $F5, $C2     { PEXT      EAX, ECX, EDX }
  {$ELSE}
  AND       RDI, $FF
  AND       RSI, $FF
  DB        $C4, $E2, $42, $F5, $C6     { PEXT      EAX, EDI, ESI }
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FF
  AND       EDX, $FF
  DB        $C4, $E2, $7A, $F5, $C2     { PEXT      EAX, EAX, EDX }
 {$ENDIF ~x64}
end;

function Fce_ParallelBitsExtract_16_Asm(Value, Mask: UInt16): UInt16; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RCX, $FFFF
  AND       RDX, $FFFF
  DB        $C4, $E2, $72, $F5, $C2     { PEXT      EAX, ECX, EDX }
  {$ELSE}
  AND       RDI, $FFFF
  AND       RSI, $FFFF
  DB        $C4, $E2, $42, $F5, $C6     { PEXT      EAX, EDI, ESI }
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FFFF
  AND       EDX, $FFFF
  DB        $C4, $E2, $7A, $F5, $C2     { PEXT      EAX, EAX, EDX }
 {$ENDIF ~x64}
end;

function Fce_ParallelBitsExtract_32_Asm(Value, Mask: UInt32): UInt32; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  DB        $C4, $E2, $72, $F5, $C2     { PEXT      EAX, ECX, EDX }
  {$ELSE}
  DB        $C4, $E2, $42, $F5, $C6     { PEXT      EAX, EDI, ESI }
  {$ENDIF ~Windows}
 {$ELSE}
  DB        $C4, $E2, $7A, $F5, $C2     { PEXT      EAX, EAX, EDX }
 {$ENDIF ~x64}
end;

function Fce_ParallelBitsExtract_64_Asm(Value, Mask: UInt64): UInt64; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  DB        $C4, $E2, $F2, $F5, $C2     { PEXT      RAX, RCX, RDX }
  {$ELSE}
  DB        $C4, $E2, $C2, $F5, $C6     { PEXT      RAX, RDI, RSI }
  {$ENDIF ~Windows}
 {$ELSE}
  MOV       EAX, DWORD PTR [Value]
  MOV       EDX, DWORD PTR [Value + 4]
  MOV       ECX, DWORD PTR [Mask]

  DB        $C4, $E2, $7A, $F5, $C1         { PEXT      EAX, EAX, ECX }
  (* PEXT      EDX, EDX, DWORD PTR [EBP + 12 {Mask + 4}] *)
  DB        $C4, $E2, $6A, $F5, $55, $0C

  { Combine results. }
  TEST      ECX, ECX
  JNZ       @Shift

  { Low dword is empty. }
  MOV       EAX, EDX
  XOR       EDX, EDX
  JMP       @RoutineEnd

@Shift:
  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $B8, $C9              { POPCNT    ECX, ECX }
  {$ELSE}
  POPCNT    ECX, ECX
  {$ENDIF ~ASM_MachineCode}

  PUSH      EBX
  XOR       EBX, EBX

  NEG       CL
  ADD       CL, 32

  SHRD      EBX, EDX, CL
  SHR       EDX, CL
  OR        EAX, EBX

  POP       EBX

@RoutineEnd:
 {$ENDIF ~x64}
end;
{$ENDIF ~PurePascal}

function ParallelBitsExtract(Value, Mask: UInt8): UInt8;
begin
  Result := Var_ParallelBitsExtract_8(Value, Mask);
end;

function ParallelBitsExtract(Value, Mask: UInt16): UInt16;
begin
  Result := Var_ParallelBitsExtract_16(Value, Mask);
end;

function ParallelBitsExtract(Value, Mask: UInt32): UInt32;
begin
  Result := Var_ParallelBitsExtract_32(Value, Mask);
end;

function ParallelBitsExtract(Value, Mask: UInt64): UInt64;
begin
  Result := Var_ParallelBitsExtract_64(Value, Mask);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Parallel bits deposit'}{$ENDIF}
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

function Fce_ParallelBitsDeposit_64_Pas(Value, Mask: UInt64): UInt64; register;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to 63 do
  begin
    if ((Mask shr I) and 1) <> 0 then
    begin
      Result := Result or UInt64(UInt64(Value and 1) shl I);
      Value := Value shr 1;
    end;
  end;
end;

{$IFNDEF PurePascal}
function Fce_ParallelBitsDeposit_8_Asm(Value, Mask: UInt8): UInt8; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RCX, $FF
  AND       RDX, $FF
  DB        $C4, $E2, $73, $F5, $C2     { PDEP      EAX, ECX, EDX }
  {$ELSE}
  AND       RDI, $FF
  AND       RSI, $FF
  DB        $C4, $E2, $43, $F5, $C6     { PDEP      EAX, EDI, ESI }
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FF
  AND       EDX, $FF
  DB        $C4, $E2, $7B, $F5, $C2     { PDEP      EAX, EAX, EDX }
 {$ENDIF ~x64}
end;

function Fce_ParallelBitsDeposit_16_Asm(Value, Mask: UInt16): UInt16; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  AND       RCX, $FFFF
  AND       RDX, $FFFF
  DB        $C4, $E2, $73, $F5, $C2     { PDEP      EAX, ECX, EDX }
  {$ELSE}
  AND       RDI, $FFFF
  AND       RSI, $FFFF
  DB        $C4, $E2, $43, $F5, $C6     { PDEP      EAX, EDI, ESI }
  {$ENDIF ~Windows}
 {$ELSE}
  AND       EAX, $FFFF
  AND       EDX, $FFFF
  DB        $C4, $E2, $7B, $F5, $C2     { PDEP      EAX, EAX, EDX }
 {$ENDIF ~x64}
end;

function Fce_ParallelBitsDeposit_32_Asm(Value, Mask: UInt32): UInt32; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  DB        $C4, $E2, $73, $F5, $C2     { PDEP      EAX, ECX, EDX }
  {$ELSE}
  DB        $C4, $E2, $43, $F5, $C6     { PDEP      EAX, EDI, ESI }
  {$ENDIF ~Windows}
 {$ELSE}
  DB        $C4, $E2, $7B, $F5, $C2     { PDEP      EAX, EAX, EDX }
 {$ENDIF ~x64}
end;

function Fce_ParallelBitsDeposit_64_Asm(Value, Mask: UInt64): UInt64; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
  DB        $C4, $E2, $F3, $F5, $C2     { PDEP      RAX, RCX, RDX }
  {$ELSE}
  DB        $C4, $E2, $C3, $F5, $C6     { PDEP      RAX, RDI, RSI }
  {$ENDIF ~Windows}
 {$ELSE}
  XOR       EAX, EAX
  MOV       EDX, DWORD PTR [Value]
  MOV       ECX, DWORD PTR [Mask]

  TEST      ECX, ECX
  JZ        @DepositHigh

  DB        $C4, $E2, $6B, $F5, $C1     { PDEP      EAX, EDX, ECX }

  {$IFDEF ASM_MachineCode}
  DB        $F3, $0F, $B8, $C9          { POPCNT    ECX, ECX }
  {$ELSE}
  POPCNT    ECX, ECX
  {$ENDIF ~ASM_MachineCode}

  CMP       ECX, 32
  CMOVAE    EDX, DWORD PTR [Value + 4]
  JAE       @DepositHigh

@Shift:
  PUSH      EBX

  MOV       EBX, DWORD PTR [Value + 4]
  SHRD      EDX, EBX, CL

  POP       EBX

@DepositHigh:
  (* PDEP      EDX, EDX, DWORD PTR [EBP + 12 {Mask + 4}] *)
  DB        $C4, $E2, $6B, $F5, $55, $0C
 {$ENDIF ~x64}
end;
{$ENDIF ~PurePascal}

function ParallelBitsDeposit(Value, Mask: UInt8): UInt8;
begin
  Result := Var_ParallelBitsDeposit_8(Value,Mask);
end;

function ParallelBitsDeposit(Value, Mask: UInt16): UInt16;
begin
  Result := Var_ParallelBitsDeposit_16(Value,Mask);
end;

function ParallelBitsDeposit(Value, Mask: UInt32): UInt32;
begin
  Result := Var_ParallelBitsDeposit_32(Value,Mask);
end;

function ParallelBitsDeposit(Value, Mask: UInt64): UInt64;
begin
  Result := Var_ParallelBitsDeposit_64(Value,Mask);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Unit initialization'}{$ENDIF}
procedure LoadDefaultFunctions;
begin
  { (1) Load pure pascal PopCount function as default function. }
  Var_PopCount_8 := Fce_PopCount_8_Pas;
  Var_PopCount_16 := Fce_PopCount_16_Pas;
  Var_PopCount_32 := Fce_PopCount_32_Pas;
  Var_PopCount_64 := Fce_PopCount_64_Pas;

  { (2) Load pure pascal LZCount function as default function. }
  Var_LZCount_8 := Fce_LZCount_8_Pas;
  Var_LZCount_16 := Fce_LZCount_16_Pas;
  Var_LZCount_32 := Fce_LZCount_32_Pas;
  Var_LZCount_64 := Fce_LZCount_64_Pas;

  { (3) Load pure pascal TZCount function as default function. }
  Var_TZCount_8 := Fce_TZCount_8_Pas;
  Var_TZCount_16 := Fce_TZCount_16_Pas;
  Var_TZCount_32 := Fce_TZCount_32_Pas;
  Var_TZCount_64 := Fce_TZCount_64_Pas;

  { (4) Load pure pascal ExtractBits function as default function. }
  Var_ExtractBits_8 := Fce_ExtractBits_8_Pas;
  Var_ExtractBits_16 := Fce_ExtractBits_16_Pas;
  Var_ExtractBits_32 := Fce_ExtractBits_32_Pas;
  Var_ExtractBits_64 := Fce_ExtractBits_64_Pas;

  { (5) Load pure pascal ParallelBitsExtract function as default function. }
  Var_ParallelBitsExtract_8 := Fce_ParallelBitsExtract_8_Pas;
  Var_ParallelBitsExtract_16 := Fce_ParallelBitsExtract_16_Pas;
  Var_ParallelBitsExtract_32 := Fce_ParallelBitsExtract_32_Pas;
  Var_ParallelBitsExtract_64 := Fce_ParallelBitsExtract_64_Pas;

  { (6) Load pure pascal ParallelBitsDeposit function as default function. }
  Var_ParallelBitsDeposit_8 := Fce_ParallelBitsDeposit_8_Pas;
  Var_ParallelBitsDeposit_16 := Fce_ParallelBitsDeposit_16_Pas;
  Var_ParallelBitsDeposit_32 := Fce_ParallelBitsDeposit_32_Pas;
  Var_ParallelBitsDeposit_64 := Fce_ParallelBitsDeposit_64_Pas;
end;

procedure Initialize;
begin
  { (1) Load default pure pascal functions. }
  LoadDefaultFunctions;

{$IF DEFINED(BO_AllowASMExtensions) AND NOT DEFINED(PurePascal)}
  { (2.1) Create CPU identification class for CPU feature detection. }
  with TCPUIdentification.Create do
    try
      { (2.2) If PopCount feature is supported by CPU, load assembler function. }
      if (Info.SupportedExtensions.POPCNT) then
      begin
        Var_PopCount_8 := Fce_PopCount_8_Asm;
        Var_PopCount_16 := Fce_PopCount_16_Asm;
        Var_PopCount_32 := Fce_PopCount_32_Asm;
        Var_PopCount_64 := Fce_PopCount_64_Asm;
      end;

      { (2.3) If LZCount feature is supported by CPU, load assembler function. }
      if (Info.ExtendedProcessorFeatures.LZCNT) then
      begin
        Var_LZCount_8 := Fce_LZCount_8_Asm;
        Var_LZCount_16 := Fce_LZCount_16_Asm;
        Var_LZCount_32 := Fce_LZCount_32_Asm;
        Var_LZCount_64 := Fce_LZCount_64_Asm;
      end;

      { (2.4) If BMI1 feature is supported by CPU, load assembler function. }
      if (Info.ProcessorFeatures.BMI1) then
      begin
        Var_TZCount_8 := Fce_TZCount_8_Asm;
        Var_TZCount_16 := Fce_TZCount_16_Asm;
        Var_TZCount_32 := Fce_TZCount_32_Asm;
        Var_TZCount_64 := Fce_TZCount_64_Asm;

        Var_ExtractBits_8 := Fce_ExtractBits_8_Asm;
        Var_ExtractBits_16 := Fce_ExtractBits_16_Asm;
        Var_ExtractBits_32 := Fce_ExtractBits_32_Asm;
        Var_ExtractBits_64 := Fce_ExtractBits_64_Asm;
      end;

      { (2.5) If BMI2 feature is supported by CPU, load assembler function. }
      if (Info.ProcessorFeatures.BMI2) then
      begin
        Var_ParallelBitsExtract_8 := Fce_ParallelBitsExtract_8_Asm;
        Var_ParallelBitsExtract_16 := Fce_ParallelBitsExtract_16_Asm;
        Var_ParallelBitsExtract_32 := Fce_ParallelBitsExtract_32_Asm;

 {$IFNDEF x64}
        if (Info.SupportedExtensions.POPCNT) then
 {$ENDIF ~x64}
          Var_ParallelBitsExtract_64 := Fce_ParallelBitsExtract_64_Asm;

        Var_ParallelBitsDeposit_8 := Fce_ParallelBitsDeposit_8_Asm;
        Var_ParallelBitsDeposit_16 := Fce_ParallelBitsDeposit_16_Asm;
        Var_ParallelBitsDeposit_32 := Fce_ParallelBitsDeposit_32_Asm;

 {$IFNDEF x64}
        if ((Info.SupportedExtensions.POPCNT) and
            (Info.ProcessorFeatures.CMOV)) then
 {$ENDIF ~x64}
          Var_ParallelBitsDeposit_64 := Fce_ParallelBitsDeposit_64_Asm;
      end;
    finally
      { (3) Finally free CPU identification class. }
      Free;
    end;
{$IFEND}
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

initialization
  Initialize;

end.
