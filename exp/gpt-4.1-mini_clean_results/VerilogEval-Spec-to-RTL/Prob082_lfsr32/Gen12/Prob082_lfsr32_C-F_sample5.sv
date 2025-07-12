module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 32, 22, 2, and 1 (0-based: 31,21,1,0)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit is the LSB of current q
            wire fb = q[0];
            // Shift right by 1, XOR with TAP_MASK only if fb is set
            next_q = (q >> 1) ^ (fb ? TAP_MASK : 32'b0);
            q <= next_q;
        end
    end

endmodule