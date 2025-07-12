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

    // Define FSM states
    localparam [1:0]
        S_WALK    = 2'd0,
        S_FALL    = 2'd1,
        S_DIG     = 2'd2;

    reg [1:0] state, next_state;

    // Direction bits: 0=left, 1=right
    reg walk_dir, next_walk_dir;     // walking direction during walk or after fall
    reg dig_dir, next_dig_dir;       // direction during digging (locked at dig start)
    reg dir_stored;                  // direction saved before fall

    // Store walk_dir before falling, used to resume walking after fall
    reg stored_dir;

    // Next state and outputs logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_walk_dir = walk_dir;
        next_dig_dir = dig_dir;
        stored_dir = walk_dir; // default store current walk_dir, only used when falling

        // FSM logic with priority: fall > dig > bump (only when walking)
        case(state)
            S_WALK: begin
                // Fall if no ground
                if (!ground) begin
                    next_state = S_FALL;
                    stored_dir = walk_dir; // save walking direction before falling
                    // walk_dir stays same until after fall
                end else if (dig) begin
                    // start digging only if on ground and not falling (guaranteed here)
                    next_state = S_DIG;
                    next_dig_dir = walk_dir; // lock dig direction at start
                end else begin
                    // walking bumps - if bumped on left, walk right; bumped right, walk left
                    // bump left or right (including both) causes direction flip
                    if (bump_left || bump_right) begin
                        next_walk_dir = ~walk_dir;
                    end
                    // remain in walk state
                    next_state = S_WALK;
                end
            end

            S_FALL: begin
                // While falling
                // Remain falling if no ground
                // Once ground returns, go back to walking in stored direction
                if (ground) begin
                    next_state = S_WALK;
                    next_walk_dir = stored_dir; // restore walking direction
                end else begin
                    next_state = S_FALL;
                    // walk_dir unchanged during fall
                end
            end

            S_DIG: begin
                // Digging continues while ground present
                // Transition to fall on losing ground
                if (!ground) begin
                    next_state = S_FALL;
                    stored_dir = dig_dir;  // direction to store before falling after dig
                end else begin
                    // continue digging
                    next_state = S_DIG;
                    // directions unchanged during dig
                end
            end

            default: begin
                // default fallback (should not happen)
                next_state = S_WALK;
                next_walk_dir = 1'b0; // left
                next_dig_dir = 1'b0;
            end
        endcase
    end

    // State and registers update, async reset
    reg dir_store_flag;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK;
            walk_dir <= 1'b0;    // walk left at reset
            dig_dir <= 1'b0;
            stored_dir <= 1'b0;
        end else begin
            // Update state
            state <= next_state;

            // Update directions
            // For walk_dir:
            // - update when walking state with bump effect or after fall
            if (next_state == S_WALK) begin
                // If coming from FALL or DIG, walk_dir set to next_walk_dir restored from stored_dir
                // else updated from bump (already in next_walk_dir)
                walk_dir <= next_walk_dir;
            end

            // For dig_dir:
            // - updated only when entering DIG state, locks walking direction at dig start
            if (state != S_DIG && next_state == S_DIG) begin
                dig_dir <= walk_dir;
            end

            // stored_dir:
            // - stored walking direction before fall; updated only when entering FALL state
            if (state != S_FALL && next_state == S_FALL) begin
                stored_dir <= walk_dir;
            end
        end
    end

    // Output logic: Moore machine, depends only on current state and direction
    always @(*) begin
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
                // should never happen, default to walking left
                walk_left = 1'b1;
            end
        endcase
    end

endmodule