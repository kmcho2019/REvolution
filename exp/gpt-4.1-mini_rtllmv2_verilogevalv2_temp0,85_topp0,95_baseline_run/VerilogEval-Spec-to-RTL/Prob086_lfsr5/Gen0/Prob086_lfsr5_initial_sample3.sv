module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Galois LFSR with taps at bit positions 5 and 3 (bits 4 and 2)
            // The feedback bit is q[0]
            // For each bit:
            // If tapped, next_bit = q[bit] ^ q[0]
            // If not tapped, next_bit = q[bit+1]
            // Shift right, so q[i] <= next_bit
            // Let's compute the next state step by step:

            // Store current q[0] (LSB) for feedback
            wire feedback = q[0];

            // Next state calculation
            // q[4] tapped: next q[4] = q[4] ^ feedback
            // q[3] not tapped: next q[3] = q[4]
            // q[2] tapped: next q[2] = q[2] ^ feedback
            // q[1] not tapped: next q[1] = q[2]
            // q[0] not tapped: next q[0] = q[1]

            q <= {
                q[4] ^ feedback,
                q[4],
                q[2] ^ feedback,
                q[2],
                q[1]
            };
        end
    end

endmodule