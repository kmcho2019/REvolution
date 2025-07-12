module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // q[0] is the output bit shifting out
            // Calculate new q bits:
            // bit 31 (index 31) = q[0] ^ q[31] (tap at bit 32)
            // bit 21 (index 21) = q[0] ^ q[21] (tap at bit 22)
            // bit 1  (index 1)  = q[0] ^ q[1]  (tap at bit 2)
            // bit 0  (index 0)  = q[0] ^ q[0]  (tap at bit 1), but this is just q[0], so new bit 0 is q[0] shifted in? 
            // Actually, in Galois LFSR, shifting right means that new MSB gets feedback, others are shifted right, except tapped bits are XORed with q[0].
            // The LSB is always the shifted out bit, no new bit is shifted in at LSB.
            // So the next state is:
            // For i from 31 down to 1:
            // if tapped bit: q[i] <= q[i-1] ^ q[0]
            // else: q[i] <= q[i-1]
            // q[0] <= q[0] shifted out bit (old q[0]) does not get replaced; it becomes q[1] in next cycle. But since shifting right, q[0] <= q[1] ^ (feedback if tapped)
            // Wait, since we shift right, the lowest bit q[0] takes q[1] value possibly XORed.
            // Let's build the logic as per taps:
            // For each bit:
            // If tap, q[i] <= q[i-1] ^ q[0]
            // Else, q[i] <= q[i-1]
            // q[0] <= q[0] shifted out: it's just q[0] <= q[0] (or q[-1], which does not exist), so q[0] <= q[0] shifted right is q[1].
            // So q[0] <= q[1] (since it's right shift).
            // Let's implement accordingly.

            q <= {
                q[0] ^ q[31],     // bit 31 tap
                q[30:22],         // bits 30 down to 22, no taps except bit22=21
                q[0] ^ q[21],     // bit 21 tap
                q[20:2],          // bits 20 down to 2, no taps except bit2=1
                q[0] ^ q[1],      // bit 1 tap
                q[0]             // bit 0 tap (bit 1 tap at position 1 is q[0]? Wait bit1 means index1, bit0 means index0)
            };

            // The above doesn't work because we have a mixture of taps in the middle bits.
            // Need to assign each bit individually:

            q[31] <= q[0] ^ q[31];
            q[30] <= q[29];
            q[29] <= q[28];
            q[28] <= q[27];
            q[27] <= q[26];
            q[26] <= q[25];
            q[25] <= q[24];
            q[24] <= q[23];
            q[23] <= q[22];
            q[22] <= q[0] ^ q[22];
            q[21] <= q[20];
            q[20] <= q[19];
            q[19] <= q[18];
            q[18] <= q[17];
            q[17] <= q[16];
            q[16] <= q[15];
            q[15] <= q[14];
            q[14] <= q[13];
            q[13] <= q[12];
            q[12] <= q[11];
            q[11] <= q[10];
            q[10] <= q[9];
            q[9]  <= q[8];
            q[8]  <= q[7];
            q[7]  <= q[6];
            q[6]  <= q[5];
            q[5]  <= q[4];
            q[4]  <= q[3];
            q[3]  <= q[2];
            q[2]  <= q[0] ^ q[2];
            q[1]  <= q[0] ^ q[1];
            q[0]  <= q[0]; // This should be q[1] but since we shift right, LSB takes the next bit, so q[0] <= q[1] but q[1] is tapped so handled above. Actually q[0] <= q[1] from old q.
        end
    end

endmodule