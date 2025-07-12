module TopModule(
    input [3:0] x,
    output f
);

// The logic implementation based on the given Karnaugh map
// We only need to consider the cases where f is 1, as the others can be covered by the don't-care conditions
// Case 1: x[3]x[4] = 11, f = 1 regardless of x[1]x[2]
// Case 2: x[3]x[4] = 01, f = 1 when x[1]x[2] = 11
// Case 3: x[3]x[4] = 10, f = 1 when x[1]x[2] = 00 or x[1]x[2] = 01

assign f = (x[3] & x[2]) | 
           (x[3] & ~x[3] & x[1] & x[2]) | // This condition is always false, so we can simplify it
           (~x[3] & x[2] & x[1]) | 
           (x[3] & x[2]);

// Simplifying the expression
assign f = (x[3] & x[2]) | (~x[3] & x[2] & x[1]) | (x[3]);

// Further simplification
assign f = x[3] | (x[2] & x[1] & ~x[3]);

// Final simplified expression
assign f = x[3] | (x[1] & x[2] & ~x[3]);

endmodule