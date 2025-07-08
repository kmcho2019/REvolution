module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    typedef enum logic [0:0] {
        WALK_LEFT = 1'b0,
        WALK_RIGHT = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (Moore outputs depend only on state)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule