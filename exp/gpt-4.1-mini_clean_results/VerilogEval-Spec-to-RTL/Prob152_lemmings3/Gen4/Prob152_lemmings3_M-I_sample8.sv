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

    // State encoding combining direction and activity
    localparam 
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic with fall > dig > bump priority and corrected bump direction checks
    always @(*) begin
        next_state = state; // default stay in current state

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling left
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    // Start digging left if on ground
                    next_state = DIG_LEFT;
                end else if (bump_left) begin
                    // Switch direction if bumped on the left side while walking left
                    next_state = WALK_RIGHT;
                end
                // If bump_right only or no bump, no direction change
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_right) begin
                    // Switch direction if bumped on the right side while walking right
                    next_state = WALK_LEFT;
                end
                // If bump_left only or no bump, no direction change
            end

            FALL_LEFT: begin
                if (ground) begin
                    // Land, resume walking left
                    next_state = WALK_LEFT;
                end
                // else remain falling
            end

            FALL_RIGHT: begin
                if (ground) begin
                    next_state = WALK_RIGHT;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // Stop digging and start falling left
                    next_state = FALL_LEFT;
                end
                // else remain digging left
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end
                // else remain digging right
            end

            default: begin
                next_state = WALK_LEFT; // fallback/reset
            end
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore output decoding
    always @(*) begin
        // Defaults
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALL_LEFT,
            FALL_RIGHT: aaah = 1'b1;
            DIG_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1;
            end
            DIG_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
            end
            default: walk_left = 1'b1; // safe default
        endcase
    end

endmodule