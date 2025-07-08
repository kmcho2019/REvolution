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

    // State encoding
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam FALL_LEFT  = 3'd2;
    localparam FALL_RIGHT = 3'd3;
    localparam DIG_LEFT   = 3'd4;
    localparam DIG_RIGHT  = 3'd5;
    localparam SPLATTER   = 3'd6;

    reg [2:0] state, next_state;
    reg [5:0] fall_counter, next_fall_counter; // 6 bits enough for >20 count

    // State register and fall_counter update with async posedge areset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            fall_counter <= next_fall_counter;
        end
    end

    // Next state logic and fall counter logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_fall_counter = fall_counter;

        case(state)
            WALK_LEFT: begin
                // Priority: fall > dig > bump
                if (!ground) begin
                    // Start falling left
                    next_state = FALL_LEFT;
                    next_fall_counter = 0;
                end else if (dig) begin
                    // Start digging left
                    next_state = DIG_LEFT;
                    // fall_counter unchanged
                end else if (bump_left || bump_right) begin
                    // Switch direction
                    // If bumped left or right or both, switch to walk right
                    next_state = WALK_RIGHT;
                    // fall_counter unchanged
                end else begin
                    // stay walking left
                    next_state = WALK_LEFT;
                end
                // fall_counter remains as is (should be zero or unused)
                next_fall_counter = 0; 
            end

            WALK_RIGHT: begin
                // Priority: fall > dig > bump
                if (!ground) begin
                    // Start falling right
                    next_state = FALL_RIGHT;
                    next_fall_counter = 0;
                end else if (dig) begin
                    // Start digging right
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    // Switch direction
                    // If bumped left or right or both, switch to walk left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
                next_fall_counter = 0;
            end

            DIG_LEFT: begin
                // While digging left on ground
                if (!ground) begin
                    // Ground gone, start falling left
                    next_state = FALL_LEFT;
                    next_fall_counter = 0;
                end else begin
                    // Continue digging
                    next_state = DIG_LEFT;
                    // fall counter unchanged
                end
            end

            DIG_RIGHT: begin
                // While digging right on ground
                if (!ground) begin
                    // Ground gone, start falling right
                    next_state = FALL_RIGHT;
                    next_fall_counter = 0;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            FALL_LEFT: begin
                // Falling left
                if (ground) begin
                    // Landed on ground
                    if (fall_counter > 20) begin
                        // splatter
                        next_state = SPLATTER;
                        next_fall_counter = 0;
                    end else begin
                        // resume walking left
                        next_state = WALK_LEFT;
                        next_fall_counter = 0;
                    end
                end else begin
                    // keep falling, increment fall_counter saturating at max 63 (just to be safe)
                    next_state = FALL_LEFT;
                    if (fall_counter == 6'd63)
                        next_fall_counter = 6'd63;
                    else
                        next_fall_counter = fall_counter + 1;
                end
            end

            FALL_RIGHT: begin
                // Falling right
                if (ground) begin
                    if (fall_counter > 20) begin
                        // splatter
                        next_state = SPLATTER;
                        next_fall_counter = 0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_counter = 0;
                    end
                end else begin
                    next_state = FALL_RIGHT;
                    if (fall_counter == 6'd63)
                        next_fall_counter = 6'd63;
                    else
                        next_fall_counter = fall_counter + 1;
                end
            end

            SPLATTER: begin
                // Dead forever until reset
                next_state = SPLATTER;
                next_fall_counter = 0;
            end

            default: begin
                // Unknown state, reset to WALK_LEFT
                next_state = WALK_LEFT;
                next_fall_counter = 0;
            end
        endcase
    end

    // Outputs depend on current state only (Moore)
    always @(*) begin
        // Defaults
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
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1;
            end
            DIG_LEFT, DIG_RIGHT: begin
                digging = 1;
            end
            SPLATTER: begin
                // all outputs zero
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule