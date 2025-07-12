module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit from current LSB
            wire feedback = q[0];

            // Declare next state variable to hold computed next LFSR value
            reg [31:0] next_q;

            // Compute next_q bits according to Galois LFSR logic with taps at bits 31,21,1,0 (0-based)
            // For tapped bits: XOR shifted bit with feedback
            // For non-tapped bits: just shift previous bit

            // MSB (bit 31) gets feedback XOR prior bit 31 shifted in (which is q[31])
            // Actually bit 31 shifts in feedback as new MSB (Example 1 and 2 agree: q[31] <= feedback)
            next_q[31] = feedback;

            // Bits 30 down to 22 shift right normally (q[i] <= q[i+1])
            next_q[30:22] = q[31:23];

            // Bit 21 tap XOR with feedback
            next_q[21] = q[22] ^ feedback;

            // Bits 20 down to 2 shift right normally
            next_q[20:2] = q[21:3];

            // Bit 1 tap XOR with feedback
            next_q[1] = q[2] ^ feedback;

            // Bit 0 tap XOR with feedback
            next_q[0] = q[1] ^ feedback;

            q <= next_q;
        end
    end

endmodule