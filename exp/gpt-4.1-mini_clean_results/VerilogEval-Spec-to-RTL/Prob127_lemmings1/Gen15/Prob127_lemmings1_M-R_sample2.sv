module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    typedef enum logic [0:0] {
        WALK_LEFT  = 1'b0,
        WALK_RIGHT = 1'b1
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            WALK_LEFT:  next_state = (bump_left || bump_right) ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = (bump_left || bump_right) ? WALK_LEFT : WALK_RIGHT;
            default:    next_state = WALK_LEFT;
        endcase
    end

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule