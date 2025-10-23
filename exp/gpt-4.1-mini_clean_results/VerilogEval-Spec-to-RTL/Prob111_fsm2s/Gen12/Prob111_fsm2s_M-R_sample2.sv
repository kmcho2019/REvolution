module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    localparam OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        if (state == OFF)
            next_state = (j) ? ON : OFF;
        else
            next_state = (k) ? OFF : ON;
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output directly assigned from state
    assign out = state;

endmodule