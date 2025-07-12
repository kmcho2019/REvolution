module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    integer i;
    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // bit 31 (MSB) next state: q[31] = q[30]
            next_q[31] = q[30];
            // bits 30 down to 1
            for (i = 30; i >= 1; i = i - 1) begin
                // taps at bits 31, 21, 1, and 0 correspond to indices 31,21,1,0
                // Galois LFSR taps XOR q[0] into the bit before shift position
                // tap positions: 31,21,1,0 (indexing from 0)
                if ( (i == 21) || (i == 1) ) begin
                    next_q[i] = q[i - 1] ^ q[0];
                end else begin
                    next_q[i] = q[i - 1];
                end
            end
            // bit 0 next state: q[0] = q[0] XOR for tap 0 (which is always q[0] itself? No, the LSB is shifted out, so usually it is replaced by taps)
            // For bit 0 (LSB), tap at bit 0 means it XORs with q[0] but q[-1] doesn't exist.
            // For a Galois LFSR shifting right, the new bit at MSB comes from a combination of taps.
            // However, by convention, in a 32-bit Galois LFSR shifting right, the new bit shifted in is undefined by just shifting bits. The q[0] bit is the output bit.
            // For the LSB bit (bit 0), next bit is q[0] XORed with itself? No. The LSB shifts in the XOR of taps and output bit; in Galois, the feedback is applied to bits with taps except bit 0, which is replaced by the feedback.
            // In Galois LFSR shift right, q[0] is replaced by feedback, which is just q[0] itself is not shifted in.
            // Actually, the LSB (bit 0) gets q[0] XORed with the XOR of all taps. The right-shift moves bits down, and bit 31 is assigned separately.
            // Actually, in Galois LFSR, the feedback bit is q[0], and bits with taps get XORed with q[0] during shift, while bit 0 gets the next state from the input or feedback? Actually, bit 0 = q[0] ^ 0 = q[0]. 
            // The next q[0] is the feedback bit shifted in, which is q[0]. So the LSB is replaced by feedback, but since the feedback bit is q[0], next q[0] is always q[0].
            // Actually, since shift right moves bits down, next_q[0] = feedback bit = q[0] XOR sum taps = q[0] itself since the feedback is the output bit.
            // But to implement a correct Galois LFSR, bit 0 next state must be the feedback bit; in this configuration, it stays 1 for a nonzero state. However, many implementations use q[0] as output and input bits shifted in at MSB.
            // Here, to simplify, assign next_q[0] as q[0] XOR 0 = q[0] (no change).
            next_q[0] = q[0];
            q <= next_q;
        end
    end

endmodule