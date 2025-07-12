module TopModule(
    input  [3:0] x,  // Input x, 4 bits
    output       f   // Output f, 1 bit
);

// Logic implementation based on Karnaugh map simplification
// The simplified SOP expression for the given Karnaugh map is:
// f = x[3]x[2]'x[1]'x[0] + x[3]x[2]x[1]'x[0] + x[3]'x[2]'x[1]'x[0] + x[3]'x[2]'x[1]x[0] + x[3]x[2]x[1]x[0]' + x[3]x[2]x[1]'x[0]'
assign f = (x[3] & ~x[2] & ~x[1] & x[0]) | 
           (x[3] & ~x[2] & x[1] & x[0]) | 
           (x[3] & x[2] & ~x[1] & ~x[0]) | 
           (x[3] & x[2] & ~x[1] & x[0]) | 
           (x[3] & x[2] & x[1] & ~x[0]) | 
           (~x[3] & ~x[2] & ~x[1] & x[0]) | 
           (~x[3] & ~x[2] & x[1] & x[0]);

endmodule