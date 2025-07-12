module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

reg sop_term1, sop_term2, sop_term3;
reg pos_term1, pos_term2, pos_term3, pos_term4, pos_term5, pos_term6, pos_term7, pos_term8, pos_term9;

always @(*) begin
    // Implementing the SOP logic
    sop_term1 = ~a & b & ~c & ~d; // Condition for input 2
    sop_term2 = ~a & b & c & d;    // Condition for input 7
    sop_term3 = a & b & c & d;      // Condition for input 15
    
    out_sop = sop_term1 | sop_term2 | sop_term3;

    // Implementing the POS logic
    pos_term1 = a & ~b & ~c & ~d;  // Condition for input 0
    pos_term2 = ~a & ~b & ~c & d;   // Condition for input 1
    pos_term3 = ~a & b & ~c & ~d;   // Condition for input 4
    pos_term4 = ~a & b & ~c & d;    // Condition for input 5
    pos_term5 = ~a & b & c & ~d;    // Condition for input 6
    pos_term6 = a & ~b & ~c & d;    // Condition for input 9
    pos_term7 = a & ~b & c & ~d;    // Condition for input 10
    pos_term8 = a & b & ~c & d;     // Condition for input 13
    pos_term9 = a & b & c & ~d;     // Condition for input 14

    out_pos = ~(pos_term1 | pos_term2 | pos_term3 | pos_term4 | pos_term5 | pos_term6 | pos_term7 | pos_term8 | pos_term9);
end

endmodule