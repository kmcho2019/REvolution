module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (b & d);

// For Minimum Product-of-Sums (POS) form, let's first define the conditions for a logic-0 output
// Since the conditions given for logic-0 are more complex and the initial thought had errors in simplification,
// we directly implement out_pos based on given conditions and logic.

// Conditions for logic-0 (out_pos):
// out_pos should be 1 for all cases except when inputs are 2, 7, or 15
// Thus, the out_pos is the negation of out_sop
assign out_pos = ~(out_sop);

endmodule