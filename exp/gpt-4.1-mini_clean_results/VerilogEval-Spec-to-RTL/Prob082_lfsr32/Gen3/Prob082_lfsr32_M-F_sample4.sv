module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0]; // feedback is LSB of current q

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // MSB shifts in from bit 30 (no tap at 32, so no XOR with feedback here)
            q[31] <= q[30];

            // bit 30 (index 30) no tap
            q[30] <= q[29];

            // bit 29 no tap
            q[29] <= q[28];

            // bit 28 no tap
            q[28] <= q[27];

            // bit 27 no tap
            q[27] <= q[26];

            // bit 26 no tap
            q[26] <= q[25];

            // bit 25 no tap
            q[25] <= q[24];

            // bit 24 no tap
            q[24] <= q[23];

            // bit 23 no tap
            q[23] <= q[22];

            // bit 22 tap (zero-based 21)
            q[22] <= q[23] ^ feedback;

            // bit 21 no tap
            q[21] <= q[20];

            // bit 20 no tap
            q[20] <= q[19];

            // bit 19 no tap
            q[19] <= q[18];

            // bit 18 no tap
            q[18] <= q[17];

            // bit 17 no tap
            q[17] <= q[16];

            // bit 16 no tap
            q[16] <= q[15];

            // bit 15 no tap
            q[15] <= q[14];

            // bit 14 no tap
            q[14] <= q[13];

            // bit 13 no tap
            q[13] <= q[12];

            // bit 12 no tap
            q[12] <= q[11];

            // bit 11 no tap
            q[11] <= q[10];

            // bit 10 no tap
            q[10] <= q[9];

            // bit 9 no tap
            q[9] <= q[8];

            // bit 8 no tap
            q[8] <= q[7];

            // bit 7 no tap
            q[7] <= q[6];

            // bit 6 no tap
            q[6] <= q[5];

            // bit 5 no tap
            q[5] <= q[4];

            // bit 4 no tap
            q[4] <= q[3];

            // bit 3 no tap
            q[3] <= q[2];

            // bit 2 tap (zero-based 1)
            q[2] <= q[3] ^ feedback;

            // bit 1 no tap
            q[1] <= q[0];

            // bit 0 tap (zero-based 0)
            q[0] <= feedback; // after shifting, bit 0 is replaced by feedback (the XORed value from taps)

            // Explanation:
            // For the LSB (q[0]) position, since it's the feedback bit itself, it effectively shifts in feedback.
            // This matches Galois LFSR's behavior of shifting right with feedback injected at tap positions.
        end
    end

endmodule