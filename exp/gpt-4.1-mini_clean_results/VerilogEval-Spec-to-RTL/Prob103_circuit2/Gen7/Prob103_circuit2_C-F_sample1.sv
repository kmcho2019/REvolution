module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Balanced XOR pairs followed by inversion for minimal depth XNOR
    assign q = ~((a ^ b) ^ (c ^ d));
endmodule