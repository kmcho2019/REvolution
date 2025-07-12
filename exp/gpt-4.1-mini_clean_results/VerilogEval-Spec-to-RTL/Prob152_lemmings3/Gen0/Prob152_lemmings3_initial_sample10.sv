module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    typedef enum logic [2:0] {
        WALK_LEFT   = 3'd0,
        WALK_RIGHT  = 3'd1,
        FALLING     = 3'd2,
        DIGGING_LEFT  = 3'd3,
        DIGGING_RIGHT = 3'd4
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        // default next state is current state
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (dig == 1) begin
                    next_state = DIGGING_LEFT;
                end else begin
                    // handle bump
                    if (bump_left || bump_right) begin
                        // switch walking direction
                        next_state = WALK_RIGHT;
                    end
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (dig == 1) begin
                    next_state = DIGGING_RIGHT;
                end else begin
                    // handle bump
                    if (bump_left || bump_right) begin
                        // switch walking direction
                        next_state = WALK_LEFT;
                    end
                end
            end

            FALLING: begin
                // falling continues while ground == 0
                // when ground == 1, resume walking in previous direction
                if (ground == 1) begin
                    // determine previous walking direction from stored state before falling
                    // The previous walking direction is stored in FALLING state? 
                    // Actually, to know which direction to resume, FALLING state alone is insufficient.
                    // Solution: store previous walking direction in a register.
                    // So FALLING state is common and direction info is saved separately.
                    // Here in combinational logic, cannot decide next_state based on previous direction stored in register.
                    // We'll solve this by having a separate reg for direction.

                    // We will implement a direction register updated on walking and digging state changes.
                    // Use that register here.

                    // This requires an extra reg: dir_is_left (1 = left, 0 = right)
                end
            end

            DIGGING_LEFT: begin
                if (ground == 0) begin
                    // ground disappeared, start falling
                    next_state = FALLING;
                end
                // dig=0 does not affect digging, digging continues until ground==0
                // bumps ignored
            end

            DIGGING_RIGHT: begin
                if (ground == 0) begin
                    // ground disappeared, start falling
                    next_state = FALLING;
                end
                // dig=0 does not affect digging, digging continues until ground==0
                // bumps ignored
            end

            default: next_state = WALK_LEFT;

        endcase
    end

    // We need a direction register to store last walking direction before falling
    reg dir_is_left; // 1 = left, 0 = right

    // Sequential logic: state and dir_is_left update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            dir_is_left <= 1'b1;  // walking left after reset
        end else begin
            // Update dir_is_left if next_state is a walking or digging state
            // because the direction changes on bump or dig start, and must be preserved through falling
            if (next_state == WALK_LEFT || next_state == DIGGING_LEFT) begin
                dir_is_left <= 1'b1;
            end else if (next_state == WALK_RIGHT || next_state == DIGGING_RIGHT) begin
                dir_is_left <= 1'b0;
            end
            // For falling, keep previous direction
            state <= next_state;

            // Additionally, when falling and ground returns, return to walking in dir_is_left direction
            // The combinational next_state logic cannot decide this because it lacks knowledge of dir_is_left.
            // So we do a trick here: modify next_state logic for FALLING after clock to handle this.
        end
    end

    // Fix the falling return logic with an additional combinational block dependent on dir_is_left
    // This can be done by modifying next_state FALLING case:

    always @(*) begin
        if (state == FALLING) begin
            if (ground == 1) begin
                if (dir_is_left)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end else begin
                next_state = FALLING;
            end
        end
    end

    // Outputs are Moore outputs depending on state only
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALLING: begin
                aaah = 1;
            end
            DIGGING_LEFT: begin
                digging = 1;
                walk_left = 1;
            end
            DIGGING_RIGHT: begin
                digging = 1;
                walk_right = 1;
            end
            default: begin
                // default outputs zero
            end
        endcase
    end

endmodule