module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case ({bump_left, bump_right})
            2'b00: next_state = state;          // no bump
            2'b01: next_state = WALK_LEFT;      // bump_right, walk left
            2'b10: next_state = WALK_RIGHT;     // bump_left, walk right
            2'b11: next_state = ~state;          // bump both, invert direction
            default: next_state = state;         // safety default
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs based on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule