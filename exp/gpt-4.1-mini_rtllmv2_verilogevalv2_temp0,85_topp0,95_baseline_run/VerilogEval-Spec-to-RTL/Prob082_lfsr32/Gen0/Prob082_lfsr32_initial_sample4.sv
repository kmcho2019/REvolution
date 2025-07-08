module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32, 22, 2, 1 in 1-based indexing
    // In zero-based indexing: 31, 21, 1, 0
    // Galois LFSR shifts right:
    // If LSB (q[0]) is 1, then bits at tap positions XOR with q[0] to form next state
    // Other bits shift right normally

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate feedback condition
            if (q[0]) begin
                // XOR tap bits with 1, shift right with XOR on tap bits
                q[31:1] <= q[31:1] ^ (32'b1 << 31 | 32'b1 << 21 | 32'b1 << 1) >> 1; // Wait, need to handle carefully
                // Above is incorrect. Let's do step-by-step:

                // shift right by 1 bit, but xor tap positions with 1 at next cycle:
                // Next bit for position i is q[i+1] XOR q[0] if i in taps else q[i+1]
                // For i = 31 down to 1:
                // q[i] = q[i+1] ^ (q[0] if i in taps else 0)
                // For i=31, q[32] doesn't exist, so q[31] = q[0] XOR q[0] if tapped? No, so q[31]=0 XOR 1=1 if tapped
                // Actually, bit 32 does not exist, so q[31] = q[0] XOR 0? No, we should assign q[31] = q[0] XOR next bit which is 0

                // Let's do this in a procedural way
                reg [31:0] next_q;
                integer i;

                begin
                    next_q[31] = q[0] ^ q[31]; // tap at bit 31 (bit 32)
                    for (i = 30; i > 21; i = i - 1) begin
                        next_q[i] = q[i+1];
                    end
                    next_q[21] = q[0] ^ q[22]; // tap at bit 21 (bit 22)
                    for (i = 20; i > 1; i = i - 1) begin
                        next_q[i] = q[i+1];
                    end
                    next_q[1] = q[0] ^ q[2]; // tap at bit 1 (bit 2)
                    next_q[0] = q[1]; // bit 0 shift right from bit 1
                    // Wait, this is too complicated.

                    // Alternative: For all bits i = 31 downto 1
                    // next_q[i] = q[i-1] ^ (q[0] if i in taps else 0)
                    // next_q[0] = q[0] (which is the output bit, but it shifts in from q[1])

                    // Let's do that:

                    // taps = bits 31,21,1,0 (since zero-based)
                    // So for i in taps, next_q[i] = q[i-1] ^ q[0]
                    // else next_q[i] = q[i-1]
                    // next_q[0] = q[0] (this is the LSB, shifts right from q[1])

                end

                next_q[0] = q[1];
                for (i = 1; i < 32; i = i + 1) begin
                    if (i == 31 || i == 21 || i == 1 || i == 0) begin
                        next_q[i] = q[i-1] ^ q[0];
                    end else begin
                        next_q[i] = q[i-1];
                    end
                end

                q <= next_q;

            end else begin
                // No XOR feedback, just shift right by 1 bit
                q <= q >> 1;
            end
        end
    end

endmodule