module TopModule(
    input  clk,
    input  areset,  // now synchronous reset
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Next state logic
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output is directly the state (Moore output)
    assign out = state;

endmodule