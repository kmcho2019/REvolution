module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 31, 21, 1, and 0 corresponding to taps at 32,22,2,1
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by one and XOR with TAP_MASK masked by feedback bit q[0]
            q <= (q >> 1) ^ (TAP_MASK & {32{q[0]}});
        end
    end

endmodule