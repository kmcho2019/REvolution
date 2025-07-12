module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    localparam WALK  = 4'b0001;
    localparam DIG   = 4'b0010;
    localparam FALL  = 4'b0100;
    localparam SPLAT = 4'b1000;

    reg [3:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    wire bump_both = bump_left & bump_right;
    wire bumped = bump_left | bump_right;
    wire splat_condition = (fall_timer > 5'd20);

    // Sequential state, direction, fall_timer update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;  // Walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational next_state, next_direction logic
    // Use separate wires and assign for clarity
    wire walking = state == WALK;
    wire digging = state == DIG;
    wire falling = state == FALL;
    wire splatted = state == SPLAT;

    // Determine next direction when walking, handling bumps
    wire [1:0] bump_dir_change = {bump_right, bump_left};
    wire change_dir_both = bump_both;
    wire change_dir_left = bump_left & ~bump_right;
    wire change_dir_right = bump_right & ~bump_left;

    // next direction logic
    always_comb begin
        next_direction = direction;
        next_state = state;
        next_fall_timer = fall_timer;

        if (splatted) begin
            // Stay splatted forever
            next_state = SPLAT;
            next_fall_timer = 5'd0;
            // direction unchanged
            next_direction = direction;
        end else if (falling) begin
            if (ground) begin
                // Landed: check splat condition
                if (splat_condition) begin
                    next_state = SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                end
                next_direction = direction;
            end else begin
                // Continue falling and increment timer (saturate at 31)
                next_state = FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end else if (walking) begin
            if (!ground) begin
                // Start falling
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Stay walking, update direction if bumped
                next_state = WALK;
                next_fall_timer = 5'd0;

                if (change_dir_both) begin
                    next_direction = ~direction;
                end else if (change_dir_left) begin
                    next_direction = 1'b1;  // walk right if bumped left
                end else if (change_dir_right) begin
                    next_direction = 1'b0;  // walk left if bumped right
                end else begin
                    next_direction = direction;
                end
            end
        end else if (digging) begin
            if (!ground) begin
                // Ground disappeared, start falling
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end else begin
            // Default fallback (should not happen)
            next_state = WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    end

    // Output logic
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule