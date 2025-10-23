module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding: 0 = OFF, 1 = ON
    reg state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            1'b0: next_state = j ? 1'b1 : 1'b0; // OFF state transitions
            1'b1: next_state = k ? 1'b0 : 1'b1; // ON state transitions
            default: next_state = 1'b0;
        endcase
    end

    // Clock enable: update state only if next_state differs from current
    wire state_chg = (next_state != state);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // OFF state
        else if (state_chg)
            state <= next_state;
    end

    // Moore output depends solely on state
    always @(*) begin
        out = state;
    end

endmodule