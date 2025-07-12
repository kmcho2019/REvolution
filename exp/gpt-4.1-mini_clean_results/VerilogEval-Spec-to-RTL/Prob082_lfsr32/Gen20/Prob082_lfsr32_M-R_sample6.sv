module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 31, 21, 1, and 0 (zero-based indexing)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    wire [31:0] next_q;

    // Combinational next state calculation
    assign next_q = (q >> 1) ^ ({32{q[0]}} & TAP_MASK);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule