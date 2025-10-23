module TopModule(
    input [7:0] in,
    output reg [2:0] pos
);

wire pos_0 = in[0] ? 3'd0 : 3'd8; // 3'd8 represents an invalid position
wire pos_1 = in[1] ? 3'd1 : 3'd8;
wire pos_2 = in[2] ? 3'd2 : 3'd8;
wire pos_3 = in[3] ? 3'd3 : 3'd8;
wire pos_4 = in[4] ? 3'd4 : 3'd8;
wire pos_5 = in[5] ? 3'd5 : 3'd8;
wire pos_6 = in[6] ? 3'd6 : 3'd8;
wire pos_7 = in[7] ? 3'd7 : 3'd8;

assign pos = (pos_0 < 3'd8 ? pos_0 :
              pos_1 < 3'd8 ? pos_1 :
              pos_2 < 3'd8 ? pos_2 :
              pos_3 < 3'd8 ? pos_3 :
              pos_4 < 3'd8 ? pos_4 :
              pos_5 < 3'd8 ? pos_5 :
              pos_6 < 3'd8 ? pos_6 :
              pos_7 < 3'd8 ? pos_7 : 3'd0);

endmodule