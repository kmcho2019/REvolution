module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for clarity and synthesis
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Combinational next-state logic using concise conditional operators
    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF)
                                    : (k ? OFF : ON);
    end

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output directly driven from state
    assign out = state;

endmodule