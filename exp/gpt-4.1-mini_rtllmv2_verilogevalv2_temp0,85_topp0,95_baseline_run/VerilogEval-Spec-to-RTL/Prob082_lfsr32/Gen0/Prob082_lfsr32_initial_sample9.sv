module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // Convert to 0-based indices: 31, 21, 1, 0
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1
            // For tapped bits, if feedback==1, toggle bit
            // Implementation: calculate next state bit by bit

            // Temporary variable for next state
            reg [31:0] next_q;

            next_q[31] = q[31] ^ feedback; // tap at bit 31 (pos 32)
            next_q[30] = q[31];            // shifted from bit 31 (no tap)
            next_q[29] = q[30];
            next_q[28] = q[29];
            next_q[27] = q[28];
            next_q[26] = q[27];
            next_q[25] = q[26];
            next_q[24] = q[25];
            next_q[23] = q[24];
            next_q[22] = q[23];
            next_q[21] = q[22] ^ feedback; // tap at bit 21 (pos 22)
            next_q[20] = q[21];
            next_q[19] = q[20];
            next_q[18] = q[19];
            next_q[17] = q[18];
            next_q[16] = q[17];
            next_q[15] = q[16];
            next_q[14] = q[15];
            next_q[13] = q[14];
            next_q[12] = q[13];
            next_q[11] = q[12];
            next_q[10] = q[11];
            next_q[9]  = q[10];
            next_q[8]  = q[9];
            next_q[7]  = q[8];
            next_q[6]  = q[7];
            next_q[5]  = q[6];
            next_q[4]  = q[5];
            next_q[3]  = q[4];
            next_q[2]  = q[3] ^ feedback; // tap at bit 1 (pos 2)
            next_q[1]  = q[2];
            next_q[0]  = q[1] ^ feedback; // tap at bit 0 (pos 1)

            q <= next_q;
        end
    end

endmodule