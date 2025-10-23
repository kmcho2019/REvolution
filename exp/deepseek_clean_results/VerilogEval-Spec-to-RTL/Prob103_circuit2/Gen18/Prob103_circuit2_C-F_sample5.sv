module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Parallel XOR tree for balanced timing
    wire ab_parity = a ^ b;
    wire cd_parity = c ^ d;
    
    // Final XNOR for even parity check
    assign q = ~(ab_parity ^ cd_parity);

endmodule