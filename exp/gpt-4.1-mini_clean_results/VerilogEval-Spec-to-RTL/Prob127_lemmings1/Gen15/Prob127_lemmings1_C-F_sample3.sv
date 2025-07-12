module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Combinational next state logic using clear optimized Boolean expression:
    // - If bumped left only => walk right
    // - If bumped right only => walk left
    // - If bumped both sides => toggle state
    // - If no bump => hold state
    always @(*) begin
        case ({bump_left, bump_right})
            2'b00: next_state = state;           // no bump, hold state
            2'b01: next_state = WALK_LEFT;       // bump_right only, walk left
            2'b10: next_state = WALK_RIGHT;      // bump_left only, walk right
            2'b11: next_state = ~state;           // bump both sides, toggle direction
            default: next_state = state;
        endcase
    end

    // Sequential state update with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;  // Reset to walk left immediately
        else
            state <= next_state;
    end

    // Outputs are Moore outputs derived from current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule