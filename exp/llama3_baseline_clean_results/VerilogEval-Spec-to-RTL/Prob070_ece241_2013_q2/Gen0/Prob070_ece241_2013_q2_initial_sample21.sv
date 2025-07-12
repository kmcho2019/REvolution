module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form
assign out_sop = (~a & ~b & c & d) | (~a & b & c & d) | (a & b & c & d);

// Since the problem doesn't directly lend itself to a simple manual calculation of the Product-of-Sums (POS) form without considering all possible minterms and maxterms,
// and given that the direct implementation of the SOP form is straightforward, the POS form implementation in Verilog can be approached by directly implementing the logic for the conditions
// that should result in a logic-0 output, considering the constraints provided.

// For POS, we look at the conditions that should produce a logic-0 and implement the complementary logic.
// The numbers 0, 1, 4, 5, 6, 9, 10, 13, 14 should produce a logic-0.
// Directly implementing the complementary logic for these conditions in Verilog:

assign out_pos = ~( (a & b & c & d) | (~a & ~b & c & d) | (~a & b & c & d) );

endmodule