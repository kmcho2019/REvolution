module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Activity states
    typedef enum logic [1:0] {
        WALKING = 2'd0,
        FALLING = 2'd1,
        DIGGING = 2'd2
    } state_t;

    state_t state, next_state;
    logic direction, next_direction; // 0=left, 1=right

    // Sequential logic: register state and direction with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 1'b0; // walk left on reset
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Combinational logic: next state and direction
    always_comb begin
        next_state = state;
        next_direction = direction;

        case(state)
            WALKING: begin
                // Priority: falling > digging > bump switch
                if (!ground) begin
                    // Fall immediately; direction unchanged
                    next_state = FALLING;
                end else if (dig) begin
                    // Start digging if on ground and walking
                    next_state = DIGGING;
                end else begin
                    // If bumped on side Lemming is walking into, switch direction
                    // bump_left causes walk right, bump_right causes walk left
                    // If both bump simultaneously, direction toggles too
                    if ( (direction == 1'b0 && bump_left) || (direction == 1'b1 && bump_right) ) begin
                        next_direction = ~direction;
                    end
                end
            end

            FALLING: begin
                // Remain falling while no ground
                if (ground) begin
                    // Land: resume walking same direction
                    next_state = WALKING;
                end
                // bump and dig inputs ignored while falling
            end

            DIGGING: begin
                if (!ground) begin
                    // Stop digging and start falling same direction
                    next_state = FALLING;
                end
                // bump and dig ignored while digging
            end

            default: begin
                // Safe default: walk left
                next_state = WALKING;
                next_direction = 1'b0;
            end
        endcase
    end

    // Outputs derived combinationally as Moore outputs

    assign walk_left  = (state == WALKING && direction == 1'b0) || (state == DIGGING && direction == 1'b0);
    assign walk_right = (state == WALKING && direction == 1'b1) || (state == DIGGING && direction == 1'b1);
    assign aaah      = (state == FALLING);
    assign digging   = (state == DIGGING);

endmodule