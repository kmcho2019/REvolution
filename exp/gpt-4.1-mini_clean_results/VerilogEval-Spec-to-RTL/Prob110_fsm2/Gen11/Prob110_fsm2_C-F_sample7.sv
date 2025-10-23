module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;
    wire state_en;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON : next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Clock enable: update state only if next_state differs to save power
    assign state_en = (next_state != state);

    // State register with asynchronous active-high reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else if (state_en)
            state <= next_state;
        // else hold state to reduce toggling and power
    end

    // Output logic (Moore output is state itself, direct assignment reduces combinational logic)
    assign out = state;

endmodule