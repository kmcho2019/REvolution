module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // TAP_MASK corresponds to taps at bits 32, 22, 2, and 1
    // Note: bit indexing is zero-based: bit 31 == position 32, etc.
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= {feedback, (q >> 1) ^ (TAP_MASK & {32{feedback}})};
    end

endmodule