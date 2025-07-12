module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Taps at bit positions 32, 22, 2, and 1 (1-based)
    // Zero-based indices are 31, 21, 1, 0
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit is the LSB of q
            wire feedback = q[0];
            // Shift right by one
            // For each tapped bit, XOR it with feedback before shifting in
            // Using a temporary variable to build the next state
            reg [31:0] next_q;
            integer i;
            next_q = q >> 1;
            for (i = 0; i < 32; i = i + 1) begin
                if (TAP_MASK[i])
                    next_q[i] = next_q[i] ^ feedback;
            end
            q <= next_q;
        end
    end

endmodule