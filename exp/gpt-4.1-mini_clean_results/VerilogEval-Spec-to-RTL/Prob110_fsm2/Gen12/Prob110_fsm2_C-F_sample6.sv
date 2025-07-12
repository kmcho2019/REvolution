module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding (1-bit for area and power efficiency)
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;
    wire state_en;

    // Combinational next-state logic using case statement
    always @(*) begin
        case (state)
            OFF:  next_state = j ? ON  : OFF;
            ON:   next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Clock enable to update state only on change (power optimization)
    assign state_en = (next_state != state);

    // Sequential logic with asynchronous active-high reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else if (state_en)
            state <= next_state;
        // else hold state to reduce toggling and dynamic power
    end

    // Moore output depends solely on current state
    assign out = (state == ON);

endmodule