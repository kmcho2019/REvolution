module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions for bits 31, 21, 1, and 0 (zero-based indexing)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            // Shift right by 1; if q[0] is 1, XOR with tap mask to toggle tapped bits
            q <= (q >> 1) ^ (TAP_MASK & {32{q[0]}});
    end

endmodule