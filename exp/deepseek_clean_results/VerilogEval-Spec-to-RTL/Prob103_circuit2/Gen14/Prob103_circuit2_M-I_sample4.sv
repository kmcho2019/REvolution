module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Explicit 4-input XNOR implementation with clear operation grouping
    assign q = ~(a ^ b ^ c ^ d);

endmodule