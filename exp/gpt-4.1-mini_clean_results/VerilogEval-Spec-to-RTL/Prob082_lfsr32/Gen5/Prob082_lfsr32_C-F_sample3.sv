module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 32, 22, 2, and 1 (0-based: 31, 21, 1, 0)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    wire [31:0] next_state;

    // Combinational next state: shift right by 1, XOR with tap mask if feedback q[0] = 1
    assign next_state = q[0] ? ((q >> 1) ^ TAP_MASK) : (q >> 1);

    always @(posedge clk) begin
        if (reset) 
            q <= 32'h1;          // synchronous active-high reset
        else
            q <= next_state;     // update with LFSR next state
    end

endmodule