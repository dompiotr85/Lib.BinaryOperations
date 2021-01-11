{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$INCLUDE BinaryOperations.Config.inc}

unit BinaryOperations.Consts;

interface

resourcestring
  SBitStrToNumber_UnknownCharacterInBitstring = 'BitStrToNumber: Unknown character (#%d) in bitstring.';
  SDataToHexStr_InvalidStringLength = 'DataToHexStr: Invalid string length (%d).';
  SHexStrToData_BufferTooSmall = 'HexStrToData: Buffer too small.';
  SHexStrToData_InvalidCharacter = 'HexStrToData: Invalid character (#%d).';
  SCompareData_MismatchInDataSize = 'CompareData: Mismatch in data sizes (%d, %d).';
  SBitOpsFunctionIsAsm_UnknownFunction = 'BitOpsFunctionIsAsm: Unknown function %d.';
  SBitOpsFunctionPas_UnknownFunction = 'BitOpsFunctionPas: Unknown function %d.';
  BitOpsFunctionAsm_UnknownFunction = 'BitOpsFunctionAsm: Unknown function %d.';

implementation

end.
