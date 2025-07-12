module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg[0] <= q_reg[31]; // Feedback for the LSB
        q_reg[1] <= q_reg[0] ^ q_reg[31]; // Tap at position 1
        q_reg[2] <= q_reg[1];
        q_reg[3] <= q_reg[2];
        q_reg[4] <= q_reg[3];
        q_reg[5] <= q_reg[4];
        q_reg[6] <= q_reg[5];
        q_reg[7] <= q_reg[6];
        q_reg[8] <= q_reg[7];
        q_reg[9] <= q_reg[8];
        q_reg[10] <= q_reg[9];
        q_reg[11] <= q_reg[10];
        q_reg[12] <= q_reg[11];
        q_reg[13] <= q_reg[12];
        q_reg[14] <= q_reg[13];
        q_reg[15] <= q_reg[14];
        q_reg[16] <= q_reg[15];
        q_reg[17] <= q_reg[16];
        q_reg[18] <= q_reg[17];
        q_reg[19] <= q_reg[18];
        q_reg[20] <= q_reg[19];
        q_reg[21] <= q_reg[20] ^ q_reg[31]; // Tap at position 21
        q_reg[22] <= q_reg[21];
        q_reg[23] <= q_reg[22];
        q_reg[24] <= q_reg[23];
        q_reg[25] <= q_reg[24];
        q_reg[26] <= q_reg[25];
        q_reg[27] <= q_reg[26];
        q_reg[28] <= q_reg[27];
        q_reg[29] <= q_reg[28];
        q_reg[30] <= q_reg[29];
        q_reg[31] <= q_reg[30] ^ q_reg[0]; // Tap at position 31
    end
end

assign q = q_reg;

endmodule