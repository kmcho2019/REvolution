module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 31, 21, 1, and 0 (0-based)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    reg [31:0] next_q;
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit is LSB of q
            wire fb = q[0];

            // MSB gets feedback
            next_q[31] = fb;

            // For other bits, shift right; tapped bits XOR with feedback
            for (i = 30; i >= 0; i = i - 1) begin
                next_q[i] = q[i+1] ^ (fb & TAP_MASK[i]);
            end

            q <= next_q;
        end
    end

endmodule