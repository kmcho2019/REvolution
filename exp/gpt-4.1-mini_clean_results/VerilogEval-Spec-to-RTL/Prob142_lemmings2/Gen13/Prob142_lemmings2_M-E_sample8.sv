module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    // State encoding using enumerated parameters for clarity
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALL       = 2'd2
    } state_t;

    state_t state, next_state;

    // Keep track of direction separately for clear semantics
    reg direction; // 0 = left, 1 = right

    // Next state and direction combinational logic
    always @(*) begin
        // Default assignments to maintain current state and direction
        next_state = state;
        // By default direction remains the same
        reg next_direction = direction;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Ground gone, start falling, keep direction
                    next_state = FALL;
                    next_direction = direction;
                end else if (bump_left || bump_right) begin
                    // On ground and bumped, flip direction
                    // bump on either side causes flip
                    next_state = (direction == 0) ? WALK_RIGHT : WALK_LEFT; // flip direction
                    next_direction = ~direction;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                    next_direction = direction;
                end else if (bump_left || bump_right) begin
                    // Flip direction on bumps while grounded
                    next_state = (direction == 1) ? WALK_LEFT : WALK_RIGHT;
                    next_direction = ~direction;
                end
            end

            FALL: begin
                if (ground) begin
                    // Land and resume walking with stored direction
                    next_state = (direction == 0) ? WALK_LEFT : WALK_RIGHT;
                    next_direction = direction;
                end
                // else remain falling, direction unchanged
            end

            default: begin
                // Default safe state
                next_state = WALK_LEFT;
                next_direction = 0;
            end
        endcase

        // Assign next direction after decisions
        next_direction = next_direction;
    end

    // Sequential logic to update state and direction
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            direction <= (next_state == FALL) ? direction : next_direction;
        end
    end

    // Output logic - Moore outputs depending on state and direction
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL: begin
                aaah = 1'b1;
            end
        endcase
    end

endmodule