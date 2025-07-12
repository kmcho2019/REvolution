module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding:
    // B = 0 (output=1)
    // A = 1 (output=0)

    reg state;
    reg next_state;

    // Next-state logic combinational
    always @* begin
        if (state == 1'b0)  // B
            next_state = (in == 1'b0) ? 1'b1 : 1'b0;
        else  // A
            next_state = (in == 1'b0) ? 1'b0 : 1'b1;
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // Reset to B
        else if (state != next_state)  // Update only if state changes to reduce toggling
            state <= next_state;
    end

    // Moore output: 1 when in B (state=0), else 0
    assign out = ~state;

endmodule