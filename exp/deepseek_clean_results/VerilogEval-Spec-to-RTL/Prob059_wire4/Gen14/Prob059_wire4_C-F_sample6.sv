module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire connections - most efficient implementation
    assign w = a;    // a -> w
    assign x = b;    // b -> x
    assign y = b;    // b -> y
    assign z = c;    // c -> z
endmodule