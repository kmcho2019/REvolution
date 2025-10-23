module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Next-state combinational logic
    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF)
                                   : (k ? OFF : ON);
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state != next_state)
            state <= next_state;
    end

    // Moore output directly from state
    assign out = state;

endmodule