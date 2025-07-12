module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask with taps at bits 31, 21, 1, and 0 (zero-based indexing)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            if (q[0])
                q <= (q >> 1) ^ TAP_MASK;
            else
                q <= q >> 1;
        end
    end

endmodule