module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // Corresponding bits (0-based): 31, 21, 1, 0
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit from LSB
            wire feedback = q[0];
            // Shift right by one bit
            // XOR the feedback with the tapped bits if feedback is 1
            q <= (q >> 1) ^ (feedback ? TAP_MASK : 32'b0);
        end
    end

endmodule