module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [3:0] out_tmp;

    assign out_tmp = in[{sel[7:4], sel[3:0]} * 4 +: 4];

    assign out = out_tmp;

endmodule