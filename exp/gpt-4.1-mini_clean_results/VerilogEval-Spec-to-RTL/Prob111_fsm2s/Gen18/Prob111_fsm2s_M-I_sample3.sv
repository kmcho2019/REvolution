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

    // Combinational next state logic
    always @(*) begin
        if (state == OFF)
            next_state = (j) ? ON : OFF;
        else // state == ON
            next_state = (k) ? OFF : ON;
    end

    // Synchronous state update with active-high reset (without conditional update)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output assigned directly from state
    assign out = state;

endmodule