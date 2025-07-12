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

    // FSM activity states
    localparam 
        WALKING = 2'd0,
        FALLING = 2'd1,
        DIGGING = 2'd2;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0 = left, 1 = right

    // Next state and direction logic (combinational)
    always @(*) begin
        // Default to current values
        next_state = state;
        next_direction = direction;

        case (state)
            WALKING: begin
                if (!ground) begin
                    // Priority 1: fall when no ground
                    next_state = FALLING;
                    // direction unchanged
                end else if (dig) begin
                    // Priority 2: start digging only if walking on ground
                    next_state = DIGGING;
                    // direction unchanged
                end else begin
                    // Priority 3: bump causes direction change only when walking on ground
                    if (bump_left && bump_right) begin
                        // Both bumped: switch direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // Bumped on left: walk right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // Bumped on right: walk left
                        next_direction = 1'b0;
                    end
                    // else direction unchanged
                    // state unchanged (WALKING)
                end
            end

            FALLING: begin
                if (ground) begin
                    // Landed: resume walking same direction
                    next_state = WALKING;
                    // direction unchanged
                end
                // else keep falling
                // bumps ignored
                // dig ignored
            end

            DIGGING: begin
                if (!ground) begin
                    // Ground gone during digging → fall
                    next_state = FALLING;
                    // direction unchanged
                end
                // else keep digging
                // bumps ignored
            end

            default: begin
                // Safety fallback
                next_state = WALKING;
                next_direction = 1'b0; // walk left by default
            end
        endcase
    end

    // State and direction registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 1'b0; // walk left on reset
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Moore outputs depend only on current state and direction
    always @(*) begin
        // Default outputs inactive
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            WALKING: begin
                if (direction == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
            DIGGING: begin
                digging = 1'b1;
                if (direction == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            default: begin
                // Defensive: output walking left
                walk_left = 1'b1;
            end
        endcase
    end

endmodule