module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Output is high for all combinations except when a=0, b=0, c=0.
    // This matches the function: out = a OR b OR c
    // Equivalently, out = NAND of inverted inputs: out = ~(~a & ~b & ~c)
    // Implemented here as a direct continuous assignment for minimal area and power.

    assign out = a | b | c;

endmodule