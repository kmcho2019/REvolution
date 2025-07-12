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

    // Action states
    typedef enum reg [1:0] {
        ACTION_WALK = 2'd0,
        ACTION_FALL = 2'd1,
        ACTION_DIG  = 2'd2
    } action_t;

    // Direction encoding
    localparam DIR_LEFT  = 1'b0;
    localparam DIR_RIGHT = 1'b1;

    reg [1:0] action_state, action_next;
    reg dir, dir_next;

    // Asynchronous positive edge reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            action_state <= ACTION_WALK;
            dir <= DIR_LEFT;
        end else begin
            action_state <= action_next;
            dir <= dir_next;
        end
    end

    // Next state and direction logic
    always @(*) begin
        // Default next state and direction stay the same
        action_next = action_state;
        dir_next = dir;

        case(action_state)
            ACTION_WALK: begin
                if (!ground) begin
                    // Fall takes highest priority
                    action_next = ACTION_FALL;
                    // direction unchanged
                end else if (dig) begin
                    // Digging if dig=1 and on ground and walking
                    action_next = ACTION_DIG;
                    // direction unchanged
                end else begin
                    // Handle bumps only when walking and grounded
                    if (bump_left && bump_right) begin
                        // Bumped on both sides: reverse direction
                        dir_next = (dir == DIR_LEFT) ? DIR_RIGHT : DIR_LEFT;
                    end else if (bump_left) begin
                        // Bumped on left: walk right
                        dir_next = DIR_RIGHT;
                    end else if (bump_right) begin
                        // Bumped on right: walk left
                        dir_next = DIR_LEFT;
                    end
                    // remain walking in updated direction
                    action_next = ACTION_WALK;
                end
            end
            ACTION_FALL: begin
                // Falling: ignore bumps and dig
                if (ground) begin
                    // Landed back on ground: resume walking in same direction
                    action_next = ACTION_WALK;
                end else begin
                    action_next = ACTION_FALL;
                end
                // direction unchanged
            end
            ACTION_DIG: begin
                // Digging: ignore bumps and dig
                if (!ground) begin
                    // Ground disappears while digging, start falling
                    action_next = ACTION_FALL;
                end else begin
                    action_next = ACTION_DIG;
                end
                // direction unchanged
            end
            default: begin
                // Defensive default state
                action_next = ACTION_WALK;
                dir_next = DIR_LEFT;
            end
        endcase
    end

    // Moore outputs based on action_state and direction
    always @(*) begin
        // Default outputs
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(action_state)
            ACTION_WALK: begin
                // Walking direction outputs
                if (dir == DIR_LEFT)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            ACTION_FALL: begin
                aaah = 1'b1;
                // No walking direction output while falling
            end
            ACTION_DIG: begin
                digging = 1'b1;
                // Walk in digging direction
                if (dir == DIR_LEFT)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
        endcase
    end

endmodule