module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Extract the output bit (LSB)
            wire lsb = q[0];
            // Compute next state
            // Shift right by 1 and conditionally XOR taps if lsb is 1
            // Taps at bits 31 (bit 32), 21 (bit 22), 1 (bit 2), and 0 (bit 1)
            // Remember indexing is 0-based in Verilog
            q[31:1] <= q[30:0] ^ ({31{lsb}} & (1 << 31 | 1 << 21 | 1 << 1 | 1 << 0));
            q[0] <= lsb; // The LSB is overwritten by shifted in bit, which is always the feedback in Galois LFSR
            // Actually in Galois LFSR, the LSB is replaced by the feedback bit which is always 1
            // But in Galois LFSR, the feedback bit is implicitly the shifted in bit, so in this case it's the new MSB
            // So the LSB is just q[1], so to be precise:
            // The next q[0] is q[1], which already assigned in q[31:1] <= ...
            // So assign q[0] = q[1] after XOR if tapped
            // But in the Galois LFSR, the LSB is shifted out, so the MSB is computed
            // The above line assigns q[31:1], q[0] remains?
            // Let's do it step by step:
            // The LFSR shifts right by 1 bit; the MSB is the XOR of lsb and taps
            // So q[31] <= q[30] ^ lsb if tap on bit 32
            // q[21] <= q[20] ^ lsb if tap on bit 22
            // q[1]  <= q[0] ^ lsb if tap on bit 2
            // q[0]  <= q[0] (shift right) which is lost, so q[0] is q[1] next clock?
            // This means q[0] <= q[1] after XOR if tap at bit 1
            // So we can assign q <= next_val;
            // We'll build next_val stepwise.

            // Let's build next_val vector
            integer i;
            reg [31:0] next_val;
            begin
                next_val = q >> 1;
                // For tapped bits, XOR with lsb
                if (lsb) begin
                    // Toggle bits at tapped positions
                    // bit 31 (pos 32) => next_val[31] ^= 1
                    next_val[31] = next_val[31] ^ 1'b1;
                    // bit 21 (pos 22)
                    next_val[21] = next_val[21] ^ 1'b1;
                    // bit 1 (pos 2)
                    next_val[1]  = next_val[1]  ^ 1'b1;
                    // bit 0 (pos 1)
                    next_val[0]  = next_val[0]  ^ 1'b1;
                end
                q <= next_val;
            end
        end
    end

endmodule