module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Hierarchical XOR tree with direct XNOR for even parity
    assign q = ~( (a ^ b) ^ (c ^ d) );

endmodule