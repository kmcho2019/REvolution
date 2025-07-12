module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 32, 22, 2, and 1 (zero-based indexing: 31, 21, 1, 0)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= q[0] ? ((q >> 1) ^ TAP_MASK) : (q >> 1);
    end

endmodule