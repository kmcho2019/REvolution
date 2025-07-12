module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Single 4-input XNOR gate implementation
    // This assumes the target library has an efficient XNOR4 implementation
    assign q = ~(a ^ b ^ c ^ d);

endmodule