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

    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON : next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Clock enable: only update state if next_state differs (transition needed)
    wire ce = (next_state != state);

    // State register with asynchronous reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else if (ce)
            state <= next_state;
    end

    // Output logic (Moore)
    assign out = state;

endmodule