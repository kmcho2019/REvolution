module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire connections for minimal overhead
    // a -> w
    assign w = a;
    // b -> x
    assign x = b;
    // b -> y (duplicate connection)
    assign y = b;
    // c -> z
    assign z = c;
endmodule