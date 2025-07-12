module TopModule(
    input  [3:0] x,
    output       f
);

wire nx3 = ~x[3];
wire nx1 = ~x[1];
wire nx0 = ~x[0];

wire term1 = nx1 | (x[2] & x[1] & nx0);
wire term2 = nx0 | x[1];

assign f = (nx3 & term1) | (x[3] & x[2] & term2);

endmodule