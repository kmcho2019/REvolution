module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [7:0] mask;
    assign mask[0] = ~in[1] & ~in[2] & ~in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign mask[1] = in[0] & ~in[2] & ~in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign mask[2] = in[0] & in[1] & ~in[3] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign mask[3] = in[0] & in[1] & in[2] & ~in[4] & ~in[5] & ~in[6] & ~in[7];
    assign mask[4] = in[0] & in[1] & in[2] & in[3] & ~in[5] & ~in[6] & ~in[7];
    assign mask[5] = in[0] & in[1] & in[2] & in[3] & in[4] & ~in[6] & ~in[7];
    assign mask[6] = in[0] & in[1] & in[2] & in[3] & in[4] & in[5] & ~in[7];
    assign mask[7] = in[0] & in[1] & in[2] & in[3] & in[4] & in[5] & in[6];

    assign pos = (in[7] & mask[7]) ? 3'd7 :
                 (in[6] & mask[6]) ? 3'd6 :
                 (in[5] & mask[5]) ? 3'd5 :
                 (in[4] & mask[4]) ? 3'd4 :
                 (in[3] & mask[3]) ? 3'd3 :
                 (in[2] & mask[2]) ? 3'd2 :
                 (in[1] & mask[1]) ? 3'd1 :
                 (in[0] & mask[0]) ? 3'd0 : 3'd0;

endmodule