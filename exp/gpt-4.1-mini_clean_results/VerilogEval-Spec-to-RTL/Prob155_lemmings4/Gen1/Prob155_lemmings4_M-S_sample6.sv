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

    // Define action states
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;
    localparam SPLATTERED = 2'b11;

    reg [1:0] action, next_action; // current action state
    reg direction, next_direction; // 0=left,1=right
    reg [4:0] fall_count, next_fall_count; // 5 bits count for fall time

    // Helper: bump detected on left, right or both
    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Asynchronous reset plus synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            action <= WALK;
            direction <= 1'b0; // left
            fall_count <= 5'd0;
        end else begin
            action <= next_action;
            direction <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Next state logic and fall_count update
    always @(*) begin
        // Defaults: hold values
        next_action = action;
        next_direction = direction;
        next_fall_count = fall_count;

        case (action)
            WALK: begin
                if (!ground) begin
                    // No ground: start falling
                    next_action = FALL;
                    next_fall_count = 5'd1; // start count at 1 on first cycle falling
                end else if (dig) begin
                    // Dig only if ground=1 and not falling
                    next_action = DIG;
                    // direction unchanged
                end else if (bump_any) begin
                    // Change direction according to bump rules
                    if (bump_both) begin
                        next_direction = ~direction; // flip direction
                    end else if (bump_only_left) begin
                        // bump left means walk right
                        next_direction = 1'b1;
                    end else if (bump_only_right) begin
                        // bump right means walk left
                        next_direction = 1'b0;
                    end
                    // remain walking
                    next_action = WALK;
                end
                // else remain walking same direction
            end

            DIG: begin
                if (!ground) begin
                    // no ground under dig => fall
                    next_action = FALL;
                    next_fall_count = 5'd1;
                end else begin
                    // continue digging, ignore bumps and dig inputs
                    next_action = DIG;
                    // direction unchanged
                end
            end

            FALL: begin
                if (ground) begin
                    // On ground now
                    if (fall_count > 5'd20) begin
                        next_action = SPLATTERED;
                    end else begin
                        next_action = WALK;
                    end
                    next_fall_count = 5'd0; // reset fall count on ground
                end else begin
                    // keep falling, increment fall count saturate to max 31
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                    // direction unchanged
                end
                // bumps and dig ignored while falling
            end

            SPLATTERED: begin
                // forever splattered until reset
                next_action = SPLATTERED;
                // direction don't care (can hold)
                next_fall_count = 5'd0;
            end

            default: begin
                // Defensive: should not happen, go to initial state
                next_action = WALK;
                next_direction = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Output logic (Moore outputs depend on current state only)
    always @(*) begin
        // default outputs
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (action)
            WALK: begin
                if (direction == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            DIG: begin
                digging = 1'b1;
                if (direction == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            FALL: begin
                aaah = 1'b1;
                // no walk output while falling
            end
            SPLATTERED: begin
                // all outputs remain zero
            end
        endcase
    end

endmodule