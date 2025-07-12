module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 32, 22, 2, and 1 (0-based indexing)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    wire [31:0] next_q;

    // Compute next state combinationally
    assign next_q = (q[0]) ? ((q >> 1) ^ TAP_MASK) : (q >> 1);

    // Register update on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule