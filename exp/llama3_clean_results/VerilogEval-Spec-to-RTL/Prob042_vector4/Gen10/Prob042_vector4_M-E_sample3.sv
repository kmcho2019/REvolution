module TopModule (
    input [7:0] in,
    output [31:0] out
);

    wire [31:0] mask;
    assign mask = (in[7] == 1'b1) ? 32'hffffff00 : 32'h00000000;
    assign out = ({{24{1'b0}}, in} | mask);

endmodule