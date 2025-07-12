module TopModule(
    input  [2:0] a,
    output [15:0] q
);

assign q = a * 16'd1232;

endmodule