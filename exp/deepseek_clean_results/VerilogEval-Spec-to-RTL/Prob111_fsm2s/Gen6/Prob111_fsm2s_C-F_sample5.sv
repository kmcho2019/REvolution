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

    // Compact state transition logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_OFF;
        else
            state <= state ? (k ? STATE_OFF : STATE_ON)  // ON state logic
                          : (j ? STATE_ON : STATE_OFF); // OFF state logic
    end

    // Direct output assignment
    assign out = state;

endmodule