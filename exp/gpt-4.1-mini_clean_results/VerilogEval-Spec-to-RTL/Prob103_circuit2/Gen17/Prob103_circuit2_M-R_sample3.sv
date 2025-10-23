module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Calculate parity of a, b, and c using reduction XOR
    // Then assign q as 1 if parity matches d, else 0 (XNOR behavior)
    assign q = ~((a ^ b ^ c) ^ d);

endmodule