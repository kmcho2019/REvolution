module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Combinational next state logic in an always block for clarity
    always @(*) begin
        if (state == OFF)
            next_state = (j) ? ON : OFF;
        else // state == ON
            next_state = (k) ? OFF : ON;
    end

    // Synchronous state update with active-high reset and update only if state changes
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state != next_state)
            state <= next_state;
    end

    // Moore output assigned directly from state
    assign out = state;

endmodule