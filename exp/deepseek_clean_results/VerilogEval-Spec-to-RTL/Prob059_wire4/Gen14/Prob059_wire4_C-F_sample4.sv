module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire assignments - most efficient implementation
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule