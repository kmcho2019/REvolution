module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output for position
);

always @(in) begin
    if (in[0]) pos = 3'd0;  // Bit 0 is the first 1 encountered
    else if (in[1]) pos = 3'd1;  // Bit 1 is the first 1 encountered
    else if (in[2]) pos = 3'd2;  // Bit 2 is the first 1 encountered
    else if (in[3]) pos = 3'd3;  // Bit 3 is the first 1 encountered
    else if (in[4]) pos = 3'd4;  // Bit 4 is the first 1 encountered
    else if (in[5]) pos = 3'd5;  // Bit 5 is the first 1 encountered
    else if (in[6]) pos = 3'd6;  // Bit 6 is the first 1 encountered
    else if (in[7]) pos = 3'd7;  // Bit 7 is the first 1 encountered
    else pos = 3'd0;  // No 1 bits encountered
end

endmodule