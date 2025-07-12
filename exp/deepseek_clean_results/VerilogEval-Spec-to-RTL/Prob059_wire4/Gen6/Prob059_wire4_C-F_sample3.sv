module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire connections - optimal PPA implementation
    assign w = a;  // Route input a to output w
    assign x = b;  // Route input b to output x
    assign y = b;  // Route input b to output y (same as x)
    assign z = c;  // Route input c to output z
endmodule