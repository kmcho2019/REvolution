module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    assign out_sop = ((~a & b & ~c & ~d) || (~a & b & c & d) || (a & b & c & d));
    
    // For out_pos, considering the conditions for out_sop and inverting them
    // However, given the complexity and potential for error in the direct product-of-sums implementation,
    // we focus on the logical conditions that determine out_pos to be 0
    assign out_pos = ~(out_sop);

endmodule