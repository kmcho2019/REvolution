module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // In 0-based indexing: 31, 21, 1, 0

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Extract the LSB (output bit)
            wire lsb = q[0];
            // Compute new bits for positions with taps
            // For Galois LFSR, when shifting right:
            // If lsb == 1, XOR the tap bit with 1, else just shift.
            // The new MSB (bit 31) is q[31] XOR lsb if bit 31 is tapped
            // Others follow similarly.

            // We'll build the new q as follows:
            // q_next[31] = q[30] ^ (lsb & tap_at_31)
            // q_next[30] = q[29]
            // ...
            // For tap bits, XOR with lsb
            // For non-tap bits, just shift right by one

            // Create new q
            reg [31:0] q_next;

            // Start from MSB to LSB
            // Bit 31: taps at 31? yes -> XOR with lsb and q[30]
            q_next[31] = q[30] ^ (lsb & 1'b1);

            // Bit 30: no tap
            q_next[30] = q[29];
            // Bit 29: no tap
            q_next[29] = q[28];
            // Bit 28: no tap
            q_next[28] = q[27];
            // Bit 27: no tap
            q_next[27] = q[26];
            // Bit 26: no tap
            q_next[26] = q[25];
            // Bit 25: no tap
            q_next[25] = q[24];
            // Bit 24: no tap
            q_next[24] = q[23];
            // Bit 23: no tap
            q_next[23] = q[22];
            // Bit 22: tap at 21? yes (bit 21)
            q_next[22] = q[21] ^ (lsb & 1'b1);
            // Bit 21:
            q_next[21] = q[20];
            // Bit 20:
            q_next[20] = q[19];
            // Bit 19:
            q_next[19] = q[18];
            // Bit 18:
            q_next[18] = q[17];
            // Bit 17:
            q_next[17] = q[16];
            // Bit 16:
            q_next[16] = q[15];
            // Bit 15:
            q_next[15] = q[14];
            // Bit 14:
            q_next[14] = q[13];
            // Bit 13:
            q_next[13] = q[12];
            // Bit 12:
            q_next[12] = q[11];
            // Bit 11:
            q_next[11] = q[10];
            // Bit 10:
            q_next[10] = q[9];
            // Bit 9:
            q_next[9] = q[8];
            // Bit 8:
            q_next[8] = q[7];
            // Bit 7:
            q_next[7] = q[6];
            // Bit 6:
            q_next[6] = q[5];
            // Bit 5:
            q_next[5] = q[4];
            // Bit 4:
            q_next[4] = q[3];
            // Bit 3:
            q_next[3] = q[2];
            // Bit 2: tap at 1? yes (bit 1)
            q_next[2] = q[1] ^ (lsb & 1'b1);
            // Bit 1: tap at 0? yes (bit 0)
            q_next[1] = q[0] ^ (lsb & 1'b1);
            // Bit 0: shifts in 0 always since we shifted right
            // Actually, in Galois LFSR, the LSB is shifted out and replaced by MSB shifted in.
            // The LSB is the output bit and is used for feedback, so q[0] is replaced by q[1]
            // But since we shifted right, the new LSB comes from bit 1. We already assigned q_next[1].
            // Actually, the lowest bit is replaced by the next bit shifted right, no new input bit.
            q_next[0] = q[0]; // This bit is shifted out, so should be overwritten, but let's align logic:

            // Actually, for Galois LFSR, the lowest bit is the feedback bit, and shifts right, so
            // The lowest bit is the output bit and is discarded, so the new bit 0 is q[1], and so on.
            // Wait, our current assignments put q_next[1] = q[0] ^ (lsb & 1) which corresponds to bit 1 in new q,
            // but bit 0 is missing, so re-arrange:

            // Let's redefine logic carefully:

            // For i in 31 down to 1:
            // if i in taps: q_next[i] = q[i-1] ^ lsb
            // else q_next[i] = q[i-1]
            // For bit 0: q_next[0] = lsb

            // That means bit 0 is just lsb (previous q[0]) shifted out.

            q_next[0] = lsb;

            q <= q_next;
        end
    end

endmodule