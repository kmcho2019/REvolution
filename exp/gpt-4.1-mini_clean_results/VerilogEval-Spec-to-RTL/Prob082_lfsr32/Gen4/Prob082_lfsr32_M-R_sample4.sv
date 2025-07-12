module TopModule (
    input clk,
    input reset,
    output [31:0] q
);

    // Tap mask for taps at bits 31, 21, 1, 0 (0-based)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    reg [31:0] lfsr_state;
    reg [31:0] next_state;

    // Combinational logic to compute next LFSR state
    always @(*) begin
        if (lfsr_state[0])
            next_state = (lfsr_state >> 1) ^ TAP_MASK;
        else
            next_state = lfsr_state >> 1;
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            lfsr_state <= 32'h1;
        else
            lfsr_state <= next_state;
    end

    // Output driven by the state register
    assign q = lfsr_state;

endmodule