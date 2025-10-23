module TopModule(
    input [2:0] a,
    output [15:0] q
);

assign q = {4'h0, a} * 16'h4E20;

endmodule