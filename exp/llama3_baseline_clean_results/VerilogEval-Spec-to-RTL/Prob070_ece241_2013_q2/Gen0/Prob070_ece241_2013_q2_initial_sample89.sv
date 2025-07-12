module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Implementing the SOP expression directly
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// For POS, directly implementing based on maxterms given
// The condition for out_pos to be 1 is when none of the maxterm conditions are met
// Hence, out_pos = ~(maxterm_0 | maxterm_1 | maxterm_4 | maxterm_5 | maxterm_6 | maxterm_9 | maxterm_10 | maxterm_13 | maxterm_14)
// Since Verilog does not directly support negation of OR operations in the assign statement without using additional logic,
// We implement the condition for out_pos to be 0, which is the OR of all maxterms, and then invert it.
assign out_pos = ~(  (~a & ~b & ~c & ~d) | 
                    (~a & ~b & ~c & d) | 
                    (~a & ~b & c & ~d) | 
                    (~a & ~b & c & d) | 
                    (~a & b & ~c & ~d) | 
                    (~a & b & c & ~d) | 
                    (a & ~b & ~c & d) | 
                    (a & b & ~c & ~d) | 
                    (~a & b & ~c & d) | 
                    (a & ~b & c & d));

endmodule