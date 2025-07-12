module TopModule(
    input [3:0] x,
    output f
);

// The Karnaugh map shows that when x[3] is low and x[1] and x[2] are both high, f should be high.
// It also shows that when x[3] is high and x[0] is high, or when x[3] and x[1] and x[2] are high, f should be high.
assign f = (x[3] & x[0]) | 
           (~x[3] & x[0] & x[1] & x[2]) | 
           (x[3] & x[1] & x[2]);

endmodule