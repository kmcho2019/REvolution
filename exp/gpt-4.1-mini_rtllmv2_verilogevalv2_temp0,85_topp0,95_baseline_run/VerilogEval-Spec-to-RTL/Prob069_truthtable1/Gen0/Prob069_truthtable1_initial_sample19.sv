module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

assign f = (x2 & ~x1) | (x1 & x3);

endmodule