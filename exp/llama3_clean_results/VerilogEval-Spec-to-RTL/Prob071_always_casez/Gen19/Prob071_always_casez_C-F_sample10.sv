module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [7:0] enc;
    assign enc[7] = in[7] & ~in[6] & ~in[5] & ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign enc[6] = in[6] & ~in[5] & ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign enc[5] = in[5] & ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign enc[4] = in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign enc[3] = in[3] & ~in[2] & ~in[1] & ~in[0];
    assign enc[2] = in[2] & ~in[1] & ~in[0];
    assign enc[1] = in[1] & ~in[0];
    assign enc[0] = in[0];

    assign pos = (enc[7]) ? 3'd7 :
                 (enc[6]) ? 3'd6 :
                 (enc[5]) ? 3'd5 :
                 (enc[4]) ? 3'd4 :
                 (enc[3]) ? 3'd3 :
                 (enc[2]) ? 3'd2 :
                 (enc[1]) ? 3'd1 :
                 (enc[0]) ? 3'd0 : 3'd0;

endmodule