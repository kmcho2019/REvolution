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
assign out_sop = (b & ~a & ~c & ~d) || (b & ~a & c & d) || (b & a & c & d);

// Using a more explicit condition for out_pos
// Product-of-sums form that covers all valid conditions
assign out_pos = ((b | ~b) & (c | ~c) & (d | ~d) & ((a & ~b & c & d) || (~a & b & ~c & ~d) || (~a & b & c & d) || (a & b & c & d)));

// Alternatively, simplifying out_pos further based on the condition that it should be the inverse of the sum of the invalid conditions
assign out_pos = ~(  (~a & ~b & ~c & ~d) || 
                    (~a & b & ~c & ~d) || 
                    (~a & ~b & c & ~d) || 
                    (~a & ~b & ~c & d) || 
                    (~a & b & c & ~d) || 
                    (~a & b & ~c & d) || 
                    (~a & ~b & c & d) || 
                    (~a & b & c & d) || 
                    (~a & ~b & ~c & ~d) || 
                    (a & ~b & ~c & ~d) || 
                    (a & ~b & c & ~d) || 
                    (a & ~b & ~c & d) || 
                    (~a & ~b & c & d) );

endmodule