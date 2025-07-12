module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    reg [31:0] next_q;

    always @* begin
        if (q[0])
            next_q = (q >> 1) ^ TAP_MASK;
        else
            next_q = q >> 1;
    end

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule