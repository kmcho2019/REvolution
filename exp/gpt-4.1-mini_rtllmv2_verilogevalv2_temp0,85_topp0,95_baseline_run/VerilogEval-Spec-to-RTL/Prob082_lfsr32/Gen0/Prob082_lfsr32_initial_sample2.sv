module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions in zero-based index (bit 31 is position 32)
    // Taps: 32, 22, 2, 1
    // zero-based: 31, 21, 1, 0
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate feedback bit which is q[0]
            wire fb = q[0];
            reg [31:0] next_q;
            
            // Bit 31 (tap at 32): XOR q[31] with feedback
            next_q[31] = q[31] ^ fb;
            
            // Bits 30 down to 22 (indices 30..22) shift right unchanged
            // For each bit i, next_q[i] = q[i-1]
            // Except bit 21 which is also a tap
            // So bits 30 down to 22:
            integer i;
            for (i = 30; i >= 22; i = i - 1) begin
                next_q[i] = q[i-1];
            end
            
            // Bit 21 tap: XOR q[21] with fb
            next_q[21] = q[21] ^ fb;
            
            // Bits 20 down to 2 shift right unchanged
            for (i = 20; i >= 2; i = i - 1) begin
                next_q[i] = q[i-1];
            end
            
            // Bit 1 tap: XOR q[1] with fb
            next_q[1] = q[1] ^ fb;
            
            // Bit 0 tap: XOR q[0] with fb
            // However, q[0] is the output bit itself, usually the LSB is loaded from q[1] or the feedback
            // In Galois LFSR shifted right, the LSB is always the feedback bit (q[0]) is replaced by the bit from q[1] for untapped
            // Because bit 0 is tapped, next_q[0] = q[0] ^ fb, but since q[0] is fb, this is fb ^ fb = 0, but we should shift right
            
            // Actually, for bit 0, it is the new bit entering, so next_q[0] is just q[1] because shift right
            // But bit 0 is a tap, so we XOR q[0] with fb, but q[0] is fb itself
            // The correct approach is:
            // next_q[0] = q[0] ^ fb for tap at bit 1 (zero based index 0)
            // But that would be 0
            // However, the LSB is the output bit, the new bit entering is q[1]
            // The LSB tap implies next_q[0] = q[0] ^ fb
            
            // In Galois configuration, the bit positions with taps XOR with the output bit (fb), and the LSB shifts in q[1]
            // But bit 0 is tapped, so next_q[0] = q[0] ^ fb; since q[0] = fb, next_q[0] = fb ^ fb = 0
            // This matches the behavior of the tapped bit XOR with fb
            
            next_q[0] = q[0] ^ fb;
            
            q <= next_q;
        end
    end

endmodule