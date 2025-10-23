module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else if (q[0])
            q <= (q >> 1) ^ TAP_MASK;
        else
            q <= q >> 1;
    end

endmodule