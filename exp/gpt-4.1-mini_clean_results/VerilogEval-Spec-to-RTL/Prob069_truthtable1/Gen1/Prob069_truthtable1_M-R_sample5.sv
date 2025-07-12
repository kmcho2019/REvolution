module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

wire nx3 = ~x3;
wire term1 = x2 & nx3;
wire term2 = x1 & x3;

assign f = term1 | term2;

endmodule