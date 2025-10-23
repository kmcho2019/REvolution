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

// One-hot encoding of states
reg walk_state, fall_state, dig_state, splat_state;
reg dir; // 0=left, 1=right
reg [4:0] fall_counter;

// Next state signals
reg walk_state_n, fall_state_n, dig_state_n, splat_state_n;
reg dir_n;
reg [4:0] fall_counter_n;

// Direction update combinational logic for bumps in walking
wire bump_both = bump_left & bump_right;

// Sequential logic: state, dir, fall_counter update with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_state   <= 1'b1;  // initial state: walking
        fall_state   <= 1'b0;
        dig_state    <= 1'b0;
        splat_state  <= 1'b0;
        dir          <= 1'b0;  // walk left initially
        fall_counter <= 5'd0;
    end else begin
        walk_state   <= walk_state_n;
        fall_state   <= fall_state_n;
        dig_state    <= dig_state_n;
        splat_state  <= splat_state_n;
        dir          <= dir_n;
        fall_counter <= fall_counter_n;
    end
end

// Next state combinational logic
always @* begin
    // Default next values to current
    walk_state_n  = walk_state;
    fall_state_n  = fall_state;
    dig_state_n   = dig_state;
    splat_state_n = splat_state;
    dir_n         = dir;
    fall_counter_n= fall_counter;

    // Priority: splat is terminal, no change
    if (splat_state) begin
        // Remain splatted forever
        walk_state_n  = 1'b0;
        fall_state_n  = 1'b0;
        dig_state_n   = 1'b0;
        splat_state_n = 1'b1;
        dir_n         = dir;
        fall_counter_n= 5'd0;
    end else if (fall_state) begin
        // Falling state logic
        if (ground) begin
            // Landed: check fall duration for splatter
            if (fall_counter > 5'd20) begin
                // Splatter
                walk_state_n  = 1'b0;
                fall_state_n  = 1'b0;
                dig_state_n   = 1'b0;
                splat_state_n = 1'b1;
                dir_n         = dir;
                fall_counter_n= 5'd0;
            end else begin
                // Land safely, back to walking
                walk_state_n  = 1'b1;
                fall_state_n  = 1'b0;
                dig_state_n   = 1'b0;
                splat_state_n = 1'b0;
                dir_n         = dir;
                fall_counter_n= 5'd0;
            end
        end else begin
            // Still falling, increment counter saturating at 31
            walk_state_n  = 1'b0;
            fall_state_n  = 1'b1;
            dig_state_n   = 1'b0;
            splat_state_n = 1'b0;
            dir_n         = dir;
            fall_counter_n= (fall_counter < 5'd31) ? fall_counter + 5'd1 : fall_counter;
        end
    end else if (dig_state) begin
        // Digging state logic
        if (!ground) begin
            // Ground lost while digging: start falling
            walk_state_n  = 1'b0;
            fall_state_n  = 1'b1;
            dig_state_n   = 1'b0;
            splat_state_n = 1'b0;
            dir_n         = dir;
            fall_counter_n= 5'd1; // first cycle falling
        end else begin
            // Continue digging; bumps and dig input ignored
            walk_state_n  = 1'b0;
            fall_state_n  = 1'b0;
            dig_state_n   = 1'b1;
            splat_state_n = 1'b0;
            dir_n         = dir;
            fall_counter_n= 5'd0;
        end
    end else if (walk_state) begin
        // Walking state logic
        if (!ground) begin
            // Ground lost: start falling
            walk_state_n  = 1'b0;
            fall_state_n  = 1'b1;
            dig_state_n   = 1'b0;
            splat_state_n = 1'b0;
            dir_n         = dir;
            fall_counter_n= 5'd1; // first cycle falling
        end else if (dig) begin
            // Start digging if on ground and walking
            walk_state_n  = 1'b0;
            fall_state_n  = 1'b0;
            dig_state_n   = 1'b1;
            splat_state_n = 1'b0;
            dir_n         = dir;
            fall_counter_n= 5'd0;
        end else begin
            // Handle bumps with correct direction logic
            if (bump_both) begin
                // Both sides bumped: toggle direction
                dir_n = ~dir;
            end else if (bump_left) begin
                // Bumped left: walk right
                dir_n = 1'b1;
            end else if (bump_right) begin
                // Bumped right: walk left
                dir_n = 1'b0;
            end else begin
                dir_n = dir;
            end
            // Remain walking
            walk_state_n  = 1'b1;
            fall_state_n  = 1'b0;
            dig_state_n   = 1'b0;
            splat_state_n = 1'b0;
            fall_counter_n= 5'd0;
        end
    end else begin
        // Safety fallback: start walking left
        walk_state_n  = 1'b1;
        fall_state_n  = 1'b0;
        dig_state_n   = 1'b0;
        splat_state_n = 1'b0;
        dir_n         = 1'b0;
        fall_counter_n= 5'd0;
    end
end

// Moore output assignments
assign walk_left  = walk_state & ~dir;
assign walk_right = walk_state & dir;
assign aaah       = fall_state;
assign digging    = dig_state;

endmodule