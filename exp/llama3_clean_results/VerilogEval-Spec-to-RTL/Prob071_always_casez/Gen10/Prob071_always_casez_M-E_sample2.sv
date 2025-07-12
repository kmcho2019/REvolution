module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    wire [3:0] msb;

    assign msb[0] = in[0] | in[1] | in[2] | in[3];
    assign msb[1] = in[4] | in[5] | in[6] | in[7];

    assign pos[0] = (in[0] | in[2]) ? (in[0] ? 1'b0 : 1'b1) : (in[4] | in[6]) ? (in[4] ? 1'b0 : 1'b1) : 1'b0;
    assign pos[1] = msb[0] ? 1'b0 : msb[1] ? 1'b1 : 1'b0;
    assign pos[2] = msb[0] ? (in[0] | in[1]) ? 1'b0 : (in[2] | in[3]) ? 1'b1 : 1'b0 : msb[1] ? (in[4] | in[5]) ? 1'b0 : (in[6] | in[7]) ? 1'b1 : 1'b0 : 1'b0;

endmodule