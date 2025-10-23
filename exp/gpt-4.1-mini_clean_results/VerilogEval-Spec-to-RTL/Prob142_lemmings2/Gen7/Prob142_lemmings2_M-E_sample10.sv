module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    typedef enum logic [1:0] {
        WALK_LEFT    = 2'd0,
        WALK_RIGHT   = 2'd1,
        FALLING_LEFT = 2'd2,
        FALLING_RIGHT= 2'd3
    } state_t;

    state_t state, next_state;

    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) 
                    next_state = FALLING_LEFT;
                else if (bump_left || bump_right) begin
                    // If bumped on left or right, switch to walking right
                    // If both bumped, still switch direction
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) 
                    next_state = FALLING_RIGHT;
                else if (bump_left || bump_right) begin
                    // Switch to walking left
                    next_state = WALK_LEFT;
                end
            end
            FALLING_LEFT: begin
                if (ground) 
                    next_state = WALK_LEFT;
                // bump signals do not affect direction while falling
            end
            FALLING_RIGHT: begin
                if (ground) 
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT; // safe default
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING_LEFT) || (state == FALLING_RIGHT);

endmodule