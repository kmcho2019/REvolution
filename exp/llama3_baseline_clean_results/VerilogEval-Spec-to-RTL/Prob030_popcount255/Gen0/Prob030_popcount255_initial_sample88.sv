module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Count the number of '1's in each group of 4 bits
wire [63:0] count4 [15:0];
genvar i;
generate
    for (i = 0; i < 64; i++) begin
        assign count4[i] = {in[4*i+3], in[4*i+2], in[4*i+1], in[4*i]};
    end
endgenerate

// Count the number of '1's in each group of 4 bits
wire [3:0] count4_sum [15:0];
genvar j;
generate
    for (j = 0; j < 64; j++) begin
        assign count4_sum[j] = {1'b0, 1'b0, 1'b0, 1'b0} +
            ({4{count4[j][0]}} & 4'b0001) +
            ({4{count4[j][1]}} & 4'b0010) +
            ({4{count4[j][2]}} & 4'b0100) +
            ({4{count4[j][3]}} & 4'b1000);
    end
endgenerate

// Count the number of '1's in each group of 16 bits
wire [4:0] count16 [3:0];
genvar k;
generate
    for (k = 0; k < 4; k++) begin
        assign count16[k] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0} +
            ({16{count4_sum[k*16+0][0]}} & 16'b00001) +
            ({16{count4_sum[k*16+1][0]}} & 16'b00010) +
            ({16{count4_sum[k*16+2][0]}} & 16'b00100) +
            ({16{count4_sum[k*16+3][0]}} & 16'b01000) +
            ({16{count4_sum[k*16+4][0]}} & 16'b10000) +
            ({16{count4_sum[k*16+5][0]}} & 16'b00001) +
            ({16{count4_sum[k*16+6][0]}} & 16'b00010) +
            ({16{count4_sum[k*16+7][0]}} & 16'b00100) +
            ({16{count4_sum[k*16+8][0]}} & 16'b01000) +
            ({16{count4_sum[k*16+9][0]}} & 16'b10000) +
            ({16{count4_sum[k*16+10][0]}} & 16'b00001) +
            ({16{count4_sum[k*16+11][0]}} & 16'b00010) +
            ({16{count4_sum[k*16+12][0]}} & 16'b00100) +
            ({16{count4_sum[k*16+13][0]}} & 16'b01000) +
            ({16{count4_sum[k*16+14][0]}} & 16'b10000) +
            ({16{count4_sum[k*16+15][0]}} & 16'b00001);
    end
endgenerate

// Count the number of '1's in each group of 64 bits
wire [6:0] count64 [0:0];
genvar l;
generate
    for (l = 0; l < 1; l++) begin
        assign count64[l] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} +
            ({4{count16[0][0]}} & 4'b0001) +
            ({4{count16[0][1]}} & 4'b0010) +
            ({4{count16[0][2]}} & 4'b0100) +
            ({4{count16[0][3]}} & 4'b1000) +
            ({4{count16[0][4]}} & 4'b0001) +
            ({4{count16[1][0]}} & 4'b0010) +
            ({4{count16[1][1]}} & 4'b0100) +
            ({4{count16[1][2]}} & 4'b1000) +
            ({4{count16[1][3]}} & 4'b0001) +
            ({4{count16[2][0]}} & 4'b0010) +
            ({4{count16[2][1]}} & 4'b0100) +
            ({4{count16[2][2]}} & 4'b1000) +
            ({4{count16[2][3]}} & 4'b0001) +
            ({4{count16[3][0]}} & 4'b0010) +
            ({4{count16[3][1]}} & 4'b0100) +
            ({4{count16[3][2]}} & 4'b1000) +
            ({4{count16[3][3]}} & 4'b0001);
    end
endgenerate

// Final count
assign out = count64[0];

endmodule