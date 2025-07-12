module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [7:0] bit_pos;

    assign bit_pos[0] = in[0];
    assign bit_pos[1] = in[1] & ~bit_pos[0];
    assign bit_pos[2] = in[2] & ~bit_pos[1] & ~bit_pos[0];
    assign bit_pos[3] = in[3] & ~bit_pos[2] & ~bit_pos[1] & ~bit_pos[0];
    assign bit_pos[4] = in[4] & ~bit_pos[3] & ~bit_pos[2] & ~bit_pos[1] & ~bit_pos[0];
    assign bit_pos[5] = in[5] & ~bit_pos[4] & ~bit_pos[3] & ~bit_pos[2] & ~bit_pos[1] & ~bit_pos[0];
    assign bit_pos[6] = in[6] & ~bit_pos[5] & ~bit_pos[4] & ~bit_pos[3] & ~bit_pos[2] & ~bit_pos[1] & ~bit_pos[0];
    assign bit_pos[7] = in[7] & ~bit_pos[6] & ~bit_pos[5] & ~bit_pos[4] & ~bit_pos[3] & ~bit_pos[2] & ~bit_pos[1] & ~bit_pos[0];

    assign pos = (bit_pos[7])? 3'd7 :
                 (bit_pos[6])? 3'd6 :
                 (bit_pos[5])? 3'd5 :
                 (bit_pos[4])? 3'd4 :
                 (bit_pos[3])? 3'd3 :
                 (bit_pos[2])? 3'd2 :
                 (bit_pos[1])? 3'd1 :
                 (bit_pos[0])? 3'd0 : 3'd0;

endmodule