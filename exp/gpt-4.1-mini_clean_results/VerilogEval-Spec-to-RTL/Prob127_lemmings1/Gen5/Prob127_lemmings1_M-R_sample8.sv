module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;
    reg next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case ({bump_left, bump_right})
            2'b10: next_state = 1'b1;       // bumped left -> walk right
            2'b01: next_state = 1'b0;       // bumped right -> walk left
            2'b11: next_state = ~state;     // both bumps -> toggle direction
            default: next_state = state;    // no bump -> hold state
        endcase
    end

    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule