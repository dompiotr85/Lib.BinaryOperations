{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}
{$IFNDEF BO_CONFIG_INC}
{$DEFINE BO_CONFIG_INC}

{ Include jedi.inc file. }
{$INCLUDE jedi\jedi.inc}

{$IFDEF SUPPORTS_LEGACYIFEND}{$LEGACYIFEND ON}{$ENDIF}

{ BO_UseLookupTable ------------------------------------------------------------

  When defined, PopCount functions will, in their PurePascal version, use lookup
  table instead of testing each bit in a passed value. }
{$DEFINE BO_UseLookupTable}

{ BO_AllowASMExtensions --------------------------------------------------------

  Allows use of x86(-64) instruction extensions in ASM.
  When defined, availability of each extension is tested at unit initialization.
  The instructions are used only when proper extension is supported. When it is
  not, pascal form of the function is called instead.

  Currently used extensions:

    CMOV      - ParallelBitsDeposit(CMOVcc)[32b,p64]
    POPCNT    - PopCount, ParallelBitsExtract[32b,p64],
                ParallelBitsDeposit[32b,p64]
    LZCNT     - LZCount
    BMI1      - TZCount(TZCNT), ExtractBits(BEXTR)
    BMI2      - ParallelBitsExtract(PEXT), ParallelBitsDeposit(PDEP)

      [32b] = 32-bit ASM variant of the function
      [p64] = function accepting 64-bit values
      (ins) = ins is a specific used instruction from the extension set }
{$DEFINE BO_AllowASMExtensions}

{$ENDIF ~BO_CONFIG_INC}

