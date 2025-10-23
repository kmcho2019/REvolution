module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // Descriptive state names
    parameter STATE_OFF = 1'b0;
    parameter STATE_ON  = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == STATE_ON) ? (k ? STATE_OFF : STATE_ON)
                                           : (j ? STATE_ON : STATE_OFF);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_OFF;
        else
            state <= next_state;
    end

    // Direct output assignment
    assign out = state;

endmodule