module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 31, 21, 1, and 0 (0-based indexing)
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1, and XOR tapped bits with feedback bit q[0]
            q <= (q >> 1) ^ (TAP_MASK & {32{q[0]}});
        end
    end

endmodule