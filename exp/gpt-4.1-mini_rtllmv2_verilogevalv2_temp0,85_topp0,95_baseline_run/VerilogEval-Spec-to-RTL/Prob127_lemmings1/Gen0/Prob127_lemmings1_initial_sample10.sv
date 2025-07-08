module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    typedef enum logic {
        WALK_LEFT  = 1'b0,
        WALK_RIGHT = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous positive edge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            WALK_LEFT: 
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            WALK_RIGHT: 
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            default:
                next_state = WALK_LEFT;
        endcase
    end

    // Outputs are based on current state (Moore)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule