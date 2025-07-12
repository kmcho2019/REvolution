module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [2:0] pos_w;

    assign pos_w[0] = in[1] | in[3] | in[5] | in[7];
    assign pos_w[1] = (in[2] | in[3]) | (in[6] | in[7]);
    assign pos_w[2] = (in[4] | in[5] | in[6] | in[7]);

    assign pos = (~in) ? 3'b000 : pos_w;

endmodule