module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions zero-based: 31, 21, 1, 0
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            reg [31:0] shifted = q >> 1;
            if (q[0]) begin
                // Only XOR feedback at tap bits
                shifted = shifted ^ TAP_MASK;
            end
            q <= shifted;
        end
    end

endmodule