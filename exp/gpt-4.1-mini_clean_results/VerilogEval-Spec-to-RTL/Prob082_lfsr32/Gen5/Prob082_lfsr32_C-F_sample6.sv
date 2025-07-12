module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 32, 22, 2, and 1 (zero-based positions 31, 21, 1, 0)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            reg feedback;
            reg [31:0] next_q;
            feedback = q[0];
            if (feedback) begin
                next_q = (q >> 1) ^ TAP_MASK;
            end else begin
                next_q = q >> 1;
            end
            q <= next_q;
        end
    end

endmodule