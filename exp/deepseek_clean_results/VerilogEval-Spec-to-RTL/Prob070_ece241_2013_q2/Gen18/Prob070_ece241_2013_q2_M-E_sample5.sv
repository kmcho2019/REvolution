module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Hierarchical SOP implementation
    wire condition_2 = ~a & ~b & ~d;
    wire condition_7 = ~a &  b &  d;
    wire condition_15 = a & b & d;
    
    assign out_sop = c & (condition_2 | condition_7 | condition_15);

    // Hierarchical POS implementation (using De Morgan's)
    wire pos_term1 = ~c;
    wire pos_term2 = a | b | ~d;
    wire pos_term3 = a | ~b | d;
    wire pos_term4 = ~a | ~b | d;
    
    assign out_pos = ~(pos_term1 | pos_term2 | pos_term3 | pos_term4);

endmodule