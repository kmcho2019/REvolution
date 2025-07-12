module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Define the conditions for out_sop in minimum sum-of-products form
// Directly include the conditions for 2 (0010), 7 (0111), and 15 (1111)
wire out_sop_condition_2 = ~a & b & ~c & ~d;
wire out_sop_condition_7 = ~a & b & c & d;
wire out_sop_condition_15 = a & b & c & d;

assign out_sop = out_sop_condition_2 | out_sop_condition_7 | out_sop_condition_15;

// Define the conditions for out_pos in minimum product-of-sums form
// Consider the complements of the conditions that lead to a logic-0 output
wire out_pos_condition = (a | ~b | c | d) & (a | ~b | ~c | d) & (~a | b | ~c | d) & (~a | b | c | ~d);

assign out_pos = out_pos_condition;

endmodule