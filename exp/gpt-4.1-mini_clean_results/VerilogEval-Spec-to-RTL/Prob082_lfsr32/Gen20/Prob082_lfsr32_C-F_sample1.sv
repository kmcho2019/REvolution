module TopModule (
    input        clk,
    input        reset,
    output reg [31:0] q
);

    // Tap mask for bits 31, 21, 1, and 0
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    wire feedback = q[0];
    wire [31:0] shifted = q >> 1;
    wire [31:0] feedback_masked = TAP_MASK & {32{feedback}};
    wire [31:0] next_q = shifted ^ feedback_masked;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule