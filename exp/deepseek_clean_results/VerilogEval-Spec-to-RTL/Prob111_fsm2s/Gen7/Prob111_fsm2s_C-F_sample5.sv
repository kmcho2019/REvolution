module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State definitions
    parameter STATE_OFF = 1'b0;
    parameter STATE_ON  = 1'b1;

    reg state;
    wire next_state;

    // Compact combinational next state logic:
    // next_state = j when in OFF state, ~k when in ON state
    assign next_state = (~state & j) | (state & ~k);

    // Synchronous state register with reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_OFF;  // Active-high reset to OFF state
        else
            state <= next_state;
    end

    // Moore output depends only on current state
    assign out = state;

endmodule