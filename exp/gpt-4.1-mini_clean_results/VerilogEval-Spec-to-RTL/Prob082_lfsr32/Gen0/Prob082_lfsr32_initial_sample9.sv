module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate feedback bit based on taps and q[0]
            // The feedback bit is q[0] XOR q[21] XOR q[1] XOR q[0]
            // Wait: Given the description, in Galois LFSR the feedback bit is the LSB output, and only taps receive XOR with LSB.
            // Correct approach: feedback bit = q[0]
            // Next q[31] = q[31] ^ feedback (tap at 32)
            // Next q[21] = q[21] ^ feedback (tap at 22)
            // Next q[1]  = q[1]  ^ feedback (tap at 2)
            // Next q[0]  = feedback (shifted in)
            // All other bits shift right unchanged
            // So we implement this logic:

            // Store current q
            reg [31:0] next_q;
            reg fb = q[0];

            next_q[31] = q[31] ^ fb;    // tap at 32 (bit 31)
            // bits 30 down to 22 shift right without XOR
            next_q[30:22] = q[31:23];
            next_q[21] = q[21] ^ fb;    // tap at 22 (bit 21)
            // bits 20 down to 2 shift right unchanged
            next_q[20:2] = q[21:3];
            next_q[1] = q[1] ^ fb;      // tap at 2 (bit 1)
            next_q[0] = fb;             // shifted in bit

            q <= next_q;
        end
    end

endmodule