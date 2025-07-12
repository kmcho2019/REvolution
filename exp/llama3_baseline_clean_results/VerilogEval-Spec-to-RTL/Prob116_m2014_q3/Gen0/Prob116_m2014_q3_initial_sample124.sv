module TopModule(
    input [3:0] x,
    output f
);

// The output f is '1' when x[3] and x[0] are both '1', 
// or when x[3] and x[0] are '01' and x[1]x[2] is either "01" or "11".
assign f = (x[3] & x[0]) | (x[3] & ~x[0] & (x[1] & ~x[2]) | (x[3] & ~x[0] & x[1] & x[2]));

endmodule