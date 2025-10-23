module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Directly define the SOP expression for out_sop
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Correctly define the maxterms for the undesired conditions for out_pos
// Note: This step involves recognizing that out_pos should be 1 when none of the undesired conditions are met
// The undesired conditions are when the inputs represent the numbers 0, 1, 4, 5, 6, 9, 10, 13, or 14
wire maxterm_0 = ~a & ~b & ~c & ~d; // 0
wire maxterm_1 = ~a & ~b & ~c & d;  // 1
wire maxterm_4 = ~a & b & ~c & ~d;  // 4
wire maxterm_5 = ~a & b & ~c & d;   // 5
wire maxterm_6 = ~a & b & c & ~d;   // 6
wire maxterm_9 = a & ~b & ~c & d;   // 9
wire maxterm_10 = a & ~b & c & ~d;  // 10
wire maxterm_13 = a & b & ~c & d;   // 13
wire maxterm_14 = a & b & c & ~d;   // 14

// Define the POS expression for out_pos, which should be 1 when any of the undesired conditions are false
// This involves using the maxterms in a way that reflects the product-of-sums logic correctly
assign out_pos = ~(maxterm_0 | maxterm_1 | maxterm_4 | maxterm_5 | maxterm_6 | maxterm_9 | maxterm_10 | maxterm_13 | maxterm_14);

endmodule