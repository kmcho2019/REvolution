module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;      // Main state (updated on rising edge)
    reg next_state;  // Shadow state (updated on falling edge)

    // Combinational transition logic
    wire state_transition = state ? ~k : j;

    // Falling edge updates next_state
    always @(negedge clk) begin
        if (reset)
            next_state <= 0;
        else
            next_state <= state_transition;
    end

    // Rising edge updates main state from next_state
    always @(posedge clk) begin
        if (reset)
            state <= 0;
        else
            state <= next_state;
    end

    assign out = state;

endmodule