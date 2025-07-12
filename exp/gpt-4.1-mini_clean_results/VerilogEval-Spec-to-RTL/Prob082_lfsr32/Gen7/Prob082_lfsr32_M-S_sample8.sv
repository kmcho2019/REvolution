module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 32, 22, 2, and 1; bit 31 corresponds to tap 32 (0-based indexing)
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= q[0] ? (q >> 1) ^ TAP_MASK : q >> 1;
    end

endmodule