// RUN: standalone-opt %s | standalone-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        // CHECK: %{{.*}} = standalone.foo %{{.*}} : i32
        %res = standalone.foo %0 : i32
        return
    }

    // CHECK-LABEL: func @standalone_types(%arg0: !standalone.custom<"10">)
    func.func @standalone_types(%arg0: !standalone.custom<"10">) {
        return
    }

    // This test simply tries to define a function which accepts a fixed-point value
    // an then just returns it. As long as this is valid MLIR, compilation will proceed.
    // CHECK-LABEL: func @standalone_types2
    func.func @standalone_types2(%arg0: !standalone.fixed<10,5>) -> !standalone.fixed<10,5> {
        return %arg0 : !standalone.fixed<10,5>
    }
}
