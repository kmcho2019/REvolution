module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 32, 22, 2, and 1 (0-based: 31, 21, 1, 0)
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= (q[0]) ? ((q >> 1) ^ TAP_MASK) : (q >> 1);
    end

endmodule