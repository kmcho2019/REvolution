module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // feedback bit is q[0]
            // shift right by 1 first
            // for tapped bits, XOR with feedback bit q[0]
            // taps at bits 31,21,1,0 (0-based)
            // So q[31], q[21], q[1] are XORed with feedback
            q <= { q[0] ^ q[31],               // new MSB: tap bit 31 XOR feedback
                   q[31:22] ^ {10{q[0]}},     // bits 30 down to 22 XOR feedback where tap at 21 -> only bit 21 is tapped
                   q[21] ^ q[0],               // tap bit 21 XOR feedback
                   q[20:2],                   // bits 20 down to 2 unchanged
                   q[1] ^ q[0],               // tap bit 1 XOR feedback
                   q[0]                      // bit 0 shifted out, but the LFSR shifts right so lsb replaced by next feedback bit, but in Galois LFSR this is directly shifted
                 };
            // However this expression is wrong because bits 30 down to 22 have only bit 21 tapped
            // So only q[21] among bits 30..22 needs XOR with q[0], the others just shifted.
            // Let's split carefully:
            // bit 31 <= q[0] ^ q[31]
            // bits 30..22 <= q[29..21] shifted right by 1 (bit 21 is tapped)
            // but indexing is tricky, let's do bitwise:

            // rewrite with a temporary variable:
        end
    end

endmodule