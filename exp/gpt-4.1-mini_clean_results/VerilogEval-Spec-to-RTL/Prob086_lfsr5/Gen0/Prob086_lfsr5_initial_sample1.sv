module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Extract bits
            // Tap bits at position 5 (q[4]) and 3 (q[2])
            // Feedback is XOR of q[0] with these tap bits
            wire feedback = q[0];

            // New bits computed with taps XORed by feedback:
            // Shift right: new q[4] = q[3]
            // new q[3] = q[2]
            // new q[2] = q[1] XOR feedback (tap at bit 3)
            // new q[1] = q[0]
            // new q[0] = q[4] XOR feedback (tap at bit 5)

            q <= {q[3],
                  q[2] ^ feedback,
                  q[1],
                  q[0],
                  q[4] ^ feedback};
        end
    end

endmodule