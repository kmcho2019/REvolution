module TopModule (
    input  wire clk,
    input  wire reset,
    output reg [4:0] q
);

    // Bit positions: [4] is bit 5, [2] is bit 3, [0] is bit 1
    // Taps at bit 5 and bit 3 (q[4], q[2])

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // Reset to 1
        end else begin
            // Calculate feedback bit as XOR of q[0] and q[4] (tap 5) and q[2] (tap 3)
            // In Galois LFSR, the XOR feedback is only applied to tapped bits during shift
            // We shift right: q[0] is shifted out, new bits are computed as follows:
            // q[4] <= q[4] ^ q[0]
            // q[3] <= q[4]
            // q[2] <= q[2] ^ q[0]
            // q[1] <= q[2]
            // q[0] <= q[1]
            // But the general approach is:
            // Start with lsb = q[0]
            // For tapped bits, the next bit is current bit XOR lsb
            // For non-tapped bits, next bit is the bit above current bit

            wire lsb = q[0];
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ lsb; // tap at bit 3
            q[3] <= q[4];
            q[4] <= lsb;        // tap at bit 5
        end
    end

endmodule