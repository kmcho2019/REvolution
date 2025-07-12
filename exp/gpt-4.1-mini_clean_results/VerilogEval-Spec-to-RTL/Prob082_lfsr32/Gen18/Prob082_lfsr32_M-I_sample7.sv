module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 32, 22, 2, and 1 (1-based)
    // Corresponds to bits 31, 21, 1, and 0 in 0-based indexing
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    reg [31:0] next_q;
    wire feedback = q[0];

    always @(*) begin
        if (feedback)
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