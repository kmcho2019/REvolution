module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32, 22, 2, 1 correspond to bits [31], [21], [1], [0] in 0-based indexing.
    // We do not use a mask for XOR here, but explicitly update bits with feedback.

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit is the current LSB (q[0])
            // Shift right by 1 for most bits
            // XOR feedback into the tapped bits after shifting
            
            reg feedback;
            reg [31:0] next_q;
            feedback = q[0];

            // Shift right by 1, msb gets 0 by default
            next_q = q >> 1;

            // XOR feedback into tapped bit positions
            // Bit 31 (tap position 32)
            next_q[31] = next_q[31] ^ feedback;
            // Bit 21 (tap position 22)
            next_q[21] = next_q[21] ^ feedback;
            // Bit 1 (tap position 2)
            next_q[1]  = next_q[1]  ^ feedback;
            // Bit 0 (tap position 1)
            next_q[0]  = next_q[0]  ^ feedback;

            q <= next_q;
        end
    end

endmodule