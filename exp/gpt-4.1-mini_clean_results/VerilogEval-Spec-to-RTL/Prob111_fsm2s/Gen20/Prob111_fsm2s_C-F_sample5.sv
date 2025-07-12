module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for clarity
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Combinational next-state logic: concise and clear
    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF)
                                   : (k ? OFF : ON);
    end

    // Sequential state update with synchronous active-high reset
    // and conditional update for power savings
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state != next_state)
            state <= next_state;
    end

    // Moore output driven directly by current state
    assign out = state;

endmodule