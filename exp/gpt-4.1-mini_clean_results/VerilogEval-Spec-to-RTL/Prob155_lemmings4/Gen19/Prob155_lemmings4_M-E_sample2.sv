module TopModule (
    input  wire clk,
    input  wire areset,        // async posedge reset
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State encoding (one-hot)
    reg walk_state;    // walking (either left or right direction)
    reg dig_state;     // digging
    reg fall_state;    // falling
    reg splat_state;   // splattered

    // Direction: 0 = left, 1 = right
    reg direction;

    // Fall timer counter (counts number of cycles in falling)
    reg [4:0] fall_counter;

    // Next-state signals
    reg next_walk_state;
    reg next_dig_state;
    reg next_fall_state;
    reg next_splat_state;
    reg next_direction;
    reg [4:0] next_fall_counter;

    // Asynchronous reset and sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_state   <= 1'b1;   // start walking
            dig_state    <= 1'b0;
            fall_state   <= 1'b0;
            splat_state  <= 1'b0;
            direction    <= 1'b0;   // walk left
            fall_counter <= 5'b0;
        end else begin
            walk_state   <= next_walk_state;
            dig_state    <= next_dig_state;
            fall_state   <= next_fall_state;
            splat_state  <= next_splat_state;
            direction    <= next_direction;
            fall_counter <= next_fall_counter;
        end
    end

    // Combinational next-state logic
    always @* begin
        // Default: hold current state and direction, zero fall counter if not falling
        next_walk_state  = walk_state;
        next_dig_state   = dig_state;
        next_fall_state  = fall_state;
        next_splat_state = splat_state;
        next_direction   = direction;
        next_fall_counter= 5'b0;

        // If already splatted, remain splatted
        if (splat_state) begin
            // all outputs zero, no changes
            next_walk_state  = 1'b0;
            next_dig_state   = 1'b0;
            next_fall_state  = 1'b0;
            next_splat_state = 1'b1;
            next_direction   = direction; // direction irrelevant now
            next_fall_counter= 5'b0;
        end else if (fall_state) begin
            // Currently falling
            if (ground) begin
                // landed on ground
                if (fall_counter > 5'd20) begin
                    // splatter
                    next_splat_state = 1'b1;
                    next_fall_state  = 1'b0;
                    next_walk_state  = 1'b0;
                    next_dig_state   = 1'b0;
                    next_direction   = direction; // direction preserved
                    next_fall_counter= 5'b0;
                end else begin
                    // resume walking same direction
                    next_walk_state  = 1'b1;
                    next_fall_state  = 1'b0;
                    next_dig_state   = 1'b0;
                    next_splat_state = 1'b0;
                    next_direction   = direction;
                    next_fall_counter= 5'b0;
                end
            end else begin
                // continue falling, increment fall counter
                next_fall_state  = 1'b1;
                next_walk_state  = 1'b0;
                next_dig_state   = 1'b0;
                next_splat_state = 1'b0;
                next_direction   = direction;
                next_fall_counter= fall_counter + 5'b1;
            end
        end else if (dig_state) begin
            // Currently digging
            if (!ground) begin
                // no ground => start falling, preserve direction, reset fall counter
                next_fall_state  = 1'b1;
                next_dig_state   = 1'b0;
                next_walk_state  = 1'b0;
                next_splat_state = 1'b0;
                next_direction   = direction;
                next_fall_counter= 5'b1; // start counting fall
            end else begin
                // continue digging
                next_dig_state   = 1'b1;
                next_walk_state  = 1'b0;
                next_fall_state  = 1'b0;
                next_splat_state = 1'b0;
                next_direction   = direction;
                next_fall_counter= 5'b0;
            end
        end else if (walk_state) begin
            // Currently walking
            if (!ground) begin
                // ground lost => start falling
                next_fall_state  = 1'b1;
                next_walk_state  = 1'b0;
                next_dig_state   = 1'b0;
                next_splat_state = 1'b0;
                next_direction   = direction;
                next_fall_counter= 5'b1; // start counting fall
            end else if (dig) begin
                // start digging if on ground and walking
                next_dig_state   = 1'b1;
                next_walk_state  = 1'b0;
                next_fall_state  = 1'b0;
                next_splat_state = 1'b0;
                next_direction   = direction;
                next_fall_counter= 5'b0;
            end else begin
                // handle bumps for direction switching
                next_dig_state   = 1'b0;
                next_fall_state  = 1'b0;
                next_splat_state = 1'b0;
                next_walk_state  = 1'b1;
                next_fall_counter= 5'b0;

                if (bump_left && bump_right) begin
                    // both bumps: reverse direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bumped on left => walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bumped on right => walk left
                    next_direction = 1'b0;
                end else begin
                    // no bump, keep direction
                    next_direction = direction;
                end
            end
        end else begin
            // Default catch: no active state -> initialize walking left
            next_walk_state  = 1'b1;
            next_dig_state   = 1'b0;
            next_fall_state  = 1'b0;
            next_splat_state = 1'b0;
            next_direction   = 1'b0;
            next_fall_counter= 5'b0;
        end
    end

    // Moore outputs from current state
    assign walk_left  = walk_state && (direction == 1'b0);
    assign walk_right = walk_state && (direction == 1'b1);
    assign aaah       = fall_state;
    assign digging    = dig_state;

endmodule