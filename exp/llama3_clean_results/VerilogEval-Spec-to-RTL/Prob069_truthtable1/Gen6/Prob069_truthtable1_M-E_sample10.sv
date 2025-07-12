module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Product term 1: x2 and not x3
wire pt1 = x2 & ~x3;

// Product term 2: x1 and x3
wire pt2 = x1 & x3;

// Sum the product terms to get the final output
assign f = pt1 | pt2;

endmodule