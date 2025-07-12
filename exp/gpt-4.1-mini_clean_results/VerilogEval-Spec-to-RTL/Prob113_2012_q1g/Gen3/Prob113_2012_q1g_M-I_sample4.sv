module TopModule(
    input  [3:0] x,
    output       f
);

wire term1 = x[3] & (~x[1]);              // Covers minterms 8,9,10,12,13
wire term2 = (~x[3]) & (~x[2]) & (~x[0]); // Covers minterms 0,2
wire term3 = x[3] & x[2] & x[1] & x[0];   // Covers minterm 15

assign f = term1 | term2 | term3;

endmodule