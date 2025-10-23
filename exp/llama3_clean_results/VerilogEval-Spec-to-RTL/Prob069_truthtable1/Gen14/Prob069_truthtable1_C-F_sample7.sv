module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using the most efficient logical expression
// and guiding the synthesis tool towards optimal PPA metrics
assign f = (x2 & ~x3) | (x1 & x3);

endmodule