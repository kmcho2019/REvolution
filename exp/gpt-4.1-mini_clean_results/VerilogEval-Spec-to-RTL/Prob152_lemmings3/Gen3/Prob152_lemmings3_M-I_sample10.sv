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

    // States encoding
    localparam [1:0]
        S_WALK = 2'd0,
        S_FALL = 2'd1,
        S_DIG  = 2'd2;

    reg [1:0] state, next_state;

    // Direction bits: 0 = left, 1 = right
    reg walk_dir, next_walk_dir;  // Current walking direction
    reg dig_dir, next_dig_dir;    // Direction locked when digging starts
    reg stored_dir, next_stored_dir; // Direction saved at start of falling, used to restore walking direction after fall

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK;
            walk_dir <= 1'b0;   // start walking left on reset
            dig_dir <= 1'b0;
            stored_dir <= 1'b0;
        end else begin
            state <= next_state;
            walk_dir <= next_walk_dir;
            dig_dir <= next_dig_dir;
            stored_dir <= next_stored_dir;
        end
    end

    // Next state and next direction logic (combinational)
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_walk_dir = walk_dir;
        next_dig_dir = dig_dir;
        next_stored_dir = stored_dir;

        case(state)
            S_WALK: begin
                if (!ground) begin
                    // Ground lost: start falling; store walking direction
                    next_state = S_FALL;
                    next_stored_dir = walk_dir;
                    // walk_dir remains unchanged here; will restore after falling
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state = S_DIG;
                    next_dig_dir = walk_dir; // lock direction at dig start
                    // walk_dir unchanged here; walk_dir reflects walking direction outside dig
                end else begin
                    // Handle bumps only while walking and on ground
                    if (bump_left || bump_right) begin
                        // Flip walking direction on bump left or right or both
                        next_walk_dir = ~walk_dir;
                    end
                    // Remain walking
                    next_state = S_WALK;
                end
            end

            S_FALL: begin
                if (ground) begin
                    // Landed on ground: resume walking in stored direction
                    next_state = S_WALK;
                    next_walk_dir = stored_dir;
                    // stored_dir remains unchanged here until next fall
                end else begin
                    // Continue falling
                    next_state = S_FALL;
                    // walk_dir unchanged while falling
                    // stored_dir unchanged while falling
                end
                // Ignore bumps and dig commands while falling
            end

            S_DIG: begin
                if (!ground) begin
                    // Lost ground while digging: start falling; store dig_dir
                    next_state = S_FALL;
                    next_stored_dir = dig_dir; // store dig_dir so walking direction restored after fall
                end else begin
                    // Continue digging on ground
                    next_state = S_DIG;
                    // Directions unchanged during digging
                end
                // Ignore bumps and dig commands while digging
            end

            default: begin
                // Default fallback: walk left
                next_state = S_WALK;
                next_walk_dir = 1'b0;
                next_dig_dir = 1'b0;
                next_stored_dir = 1'b0;
            end
        endcase
    end

    // Output logic: Moore outputs depend only on current state and direction
    always @(*) begin
        // Default outputs all zero
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            S_WALK: begin
                if (walk_dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            S_FALL: begin
                aaah = 1'b1;
            end
            S_DIG: begin
                digging = 1'b1;
                if (dig_dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            default: begin
                // Should not happen; default to walking left
                walk_left = 1'b1;
            end
        endcase
    end

endmodule