module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Directly considering the valid conditions for out_sop to be logic-1
// Using conditional statements for clarity
assign out_sop = (b & ~a & ~c & ~d) || (b & ~a & c & d) || (a & b & c & d);

// Implementing the minimum product-of-sums form for out_pos
// This form should directly cover the valid conditions
// Given the binary numbers that should result in a logic-1 for out_sop (and thus a logic-1 for out_pos),
// we find that out_pos should be logic-1 when the following conditions are met:
// - For 2: b is 1, and at least one of a, c, or d is 0
// - For 7: b, c, and d are 1, and a is 0
// - For 15: a, b, c, and d are all 1
// Considering the inverse conditions for out_pos to be logic-0:
// out_pos is logic-0 when none of the above conditions are met
// Thus, out_pos can be implemented as the inverse of the sum of these invalid conditions
assign out_pos = ~(  (~a & ~b & ~c & ~d) || 
                    (~a & b & ~c & ~d) || 
                    (~a & ~b & c & ~d) || 
                    (~a & ~b & ~c & d) || 
                    (~a & b & c & ~d) || 
                    (~a & b & ~c & d) || 
                    (~a & ~b & c & d) || 
                    (~a & b & c & d) || 
                    (a & ~b & ~c & ~d) || 
                    (a & ~b & c & ~d) || 
                    (a & ~b & ~c & d) || 
                    (~a & ~b & c & d) );

endmodule