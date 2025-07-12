module TopModule (
    input [7:0] in,
    output [31:0] out
);

    reg [31:0] mask;
    assign mask = (in[7])? 32'hFFFFFF00 : 32'h00000000;
    assign out = mask | (in << 24);

endmodule