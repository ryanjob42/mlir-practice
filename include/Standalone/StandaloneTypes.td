//===- StandaloneTypes.td - Standalone dialect types -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STANDALONE_TYPES
#define STANDALONE_TYPES

include "mlir/IR/AttrTypeBase.td"
include "Standalone/StandaloneDialect.td"

//===----------------------------------------------------------------------===//
// Standalone type definitions
//===----------------------------------------------------------------------===//

// Per the link below, it's common to have one TableGen "class"
// from which all types in our dialect inherit from.
// In TableGen, a "class" is used to describe inheritance,
// while "def" describes an actual C++ code.
// In this file, the "def" sections generate C++ classes,
// and the "class" section is just to help with specifying
// how those C++ classes inherit from MLIR's classes.
class Standalone_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<Standalone_Dialect, name, traits> {

  // This "mnemonic" field is the textual representation of this type in MLIR.
  let mnemonic = typeMnemonic;
}

// This is the example "Custom" type per MLIR's example.
// Effectively, it is a wrapper around a value.
def Standalone_CustomType : Standalone_Type<"Custom", "custom"> {
    // Types should have a summary and description that MLIR can use.
    let summary = "Standalone custom type";
    let description = "Custom type in standalone dialect";

    // This defines the inputs (shortened to "ins", the plural of "in") to the type.
    // Here, we're requiring one input which is a string reference.
    // This kind of parameter was defined by MLIR and requires a description of the value.
    // Note: not everything requires a description, this is just how MLIR set it up.
    // Then, we indicate that we refer to the value as "$value".
    let parameters = (ins StringRefParameter<"the custom value">:$value);

    // This defines how the "Custom" type is printed in MLIR.
    // It overrides the default way it would be printed.
    // This is more human readable, though.
    // It references the name "$value" defined in the parameters.
    let assemblyFormat = "`<` $value `>`";
}

// I've created this "FixedPoint" type, which represents a fixed-point value
// in an arbitrary base numbering system. It requires two parameters:
// the base system to use, and the number of digits after the radix to keep.
def Standalone_FixedPointType : Standalone_Type<"FixedPoint", "fixed"> {
    let summary = "Standalone fixed-point type";
    let description = "Fixed-point type in standalone dialect";

    // The base and number of digits are each an "int".
    let parameters = (ins
        "int":$base,
        "int":$digits
    );

    let assemblyFormat = "`<` $base `,` $digits `>`";
}

#endif // STANDALONE_TYPES
