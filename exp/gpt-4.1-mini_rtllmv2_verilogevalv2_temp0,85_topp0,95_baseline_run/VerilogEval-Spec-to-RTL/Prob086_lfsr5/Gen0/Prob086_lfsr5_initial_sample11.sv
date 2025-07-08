module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // On positive edge of clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // reset to 1
        end else begin
            // Compute the feedback bit: XOR of q[0] and q[2] (bit 3 position)
            // Note: bit positions are 1-based, so position 5 = q[4], position 3 = q[2]
            wire feedback = q[0] ^ q[2];

            // Shift right by one bit, but tapped bits are XORed with feedback
            // In Galois configuration, the bits at taps are XORed with feedback, others just shifted.
            // q[4] <= q[3] ^ feedback (tap at bit 5)
            // q[3] <= q[2]
            // q[2] <= q[1] ^ feedback (tap at bit 3)
            // q[1] <= q[0]
            // q[0] <= feedback (new input from feedback)
            q <= { q[3] ^ feedback, q[2], q[1] ^ feedback, q[0], feedback };
        end
    end

endmodule