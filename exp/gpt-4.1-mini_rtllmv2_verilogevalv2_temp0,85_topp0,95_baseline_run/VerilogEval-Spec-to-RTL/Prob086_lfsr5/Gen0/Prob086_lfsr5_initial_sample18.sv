module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // Taps at bit positions 5 and 3 (1-based indexing) correspond to q[4] and q[2]
    // Galois LFSR update on positive clock edge
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // reset to 1
        end else begin
            // Calculate the feedback bit - output bit q[0]
            // For Galois LFSR, feedback is applied during shifting at tap positions
            // Shift right by 1 bit, applying feedback XOR at taps

            // Save current q[0] for feedback
            wire feedback = q[0];

            // Update bits with taps
            // q[4] (bit 5) tap: new q[4] = q[4] ^ feedback
            // q[3] no tap: new q[3] = q[4]
            // q[2] (bit 3) tap: new q[2] = q[2] ^ feedback
            // q[1] no tap: new q[1] = q[2]
            // q[0] no tap: new q[0] = q[1]

            // We'll build next_q as a temporary variable
            reg [4:0] next_q;
            next_q[4] = q[4] ^ feedback;
            next_q[3] = q[4];
            next_q[2] = q[2] ^ feedback;
            next_q[1] = q[2];
            next_q[0] = q[1];

            q <= next_q;
        end
    end

endmodule