module TopModule(
    input  [3:0] x,
    output       f
);

wire nx1 = ~x[1];
wire nx0 = ~x[0];

assign f = (nx1 & nx0) | (x[3] & x[2]) | (x[3] & nx0);

endmodule