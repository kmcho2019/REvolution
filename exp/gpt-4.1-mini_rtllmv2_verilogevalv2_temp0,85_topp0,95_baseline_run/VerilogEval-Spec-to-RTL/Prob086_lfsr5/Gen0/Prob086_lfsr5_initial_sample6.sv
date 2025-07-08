module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // feedback bit is q[0]
            wire feedback = q[0];
            // Calculate next state bits:
            // For Galois LFSR shifting right:
            // bit 4: q[4] <= q[3] XOR feedback (tapped)
            // bit 3: q[3] <= q[2] (no tap)
            // bit 2: q[2] <= q[1] XOR feedback (tapped)
            // bit 1: q[1] <= q[0] (no tap)
            // bit 0: q[0] <= feedback (shifted in)
            q[0] <= q[4] ^ feedback; // Actually, bit 0 gets q[4]^feedback in a right shift with taps at bits 5 and 3 in Galois LFSR? Let's be careful.

            // Wait, in Galois LFSR, the LSB shifts out and feedback modifies tapped bits before shift.

            // Standard Galois LFSR to shift right:
            // The LSB is output as feedback.
            // For each bit i from MSB to LSB+1:
            // if bit i is tapped: q[i] <= q[i-1] XOR feedback
            // else q[i] <= q[i-1]
            // And q[0] <= feedback (shifted in)

            // So:
            // q[4] <= q[3] XOR feedback (tap)
            // q[3] <= q[2] (no tap)
            // q[2] <= q[1] XOR feedback (tap)
            // q[1] <= q[0] (no tap)
            // q[0] <= feedback

            q <= {q[3] ^ feedback, q[2], q[1] ^ feedback, q[0], feedback};
        end
    end

endmodule