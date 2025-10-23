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
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground)
                    // Return to previous walking direction?
                    // Problem states resumes walking in same direction as before falling.
                    // Here, we can keep track of prior direction in a register,
                    // but to keep single state, assume FALLING remembers direction in next_state transitions:
                    // To keep direction info, fallback to last walking state before fall.
                    if (state == FALLING)
                        next_state = (state_last_direction == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                    else
                        next_state = WALK_LEFT; // fallback safe default
                else
                    next_state = FALLING;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // To remember direction before falling, create a separate register.
    reg prior_direction; // 0=left,1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state           <= WALK_LEFT;
            prior_direction <= 1'b0;
        end else begin
            state <= next_state;

            // Update prior_direction only when walking and not falling
            if (state == WALK_LEFT)
                prior_direction <= 1'b0;
            else if (state == WALK_RIGHT)
                prior_direction <= 1'b1;
            // When falling, prior_direction does not change
        end
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule