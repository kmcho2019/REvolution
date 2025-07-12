module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Define combined states encoding mode+direction (direction in LSB)
    // 0: walk left, 1: walk right,
    // 2: dig left, 3: dig right,
    // 4: fall left, 5: fall right,
    // 6: splat left, 7: splat right
    typedef enum logic [2:0] {
        WALK_L = 3'd0,
        WALK_R = 3'd1,
        DIG_L  = 3'd2,
        DIG_R  = 3'd3,
        FALL_L = 3'd4,
        FALL_R = 3'd5,
        SPLAT_L= 3'd6,
        SPLAT_R= 3'd7
    } state_t;

    state_t state, next_state;

    // Fall timer counts fall cycles; 5-bit enough (0 to 31)
    // Incremented only when falling, else cleared
    reg [4:0] fall_timer, next_fall_timer;

    // Flag to indicate fall exceeded threshold (20 cycles)
    wire fall_too_long = (fall_timer >= 5'd20);

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Direction extraction helper
    wire direction = state[0]; // LSB encodes direction: 0=left, 1=right

    // Next state logic separated into combinational assigns

    // Compute next direction on bump when walking
    // If bumped both sides, toggle direction; else set direction accordingly
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Direction after bump (only valid in walking)
    wire bumped_direction = bump_both ? ~direction :
                            bump_left ? 1'b1 :   // walk right
                            bump_right ? 1'b0 : direction;

    // Next state computation
    // Priority: fall > dig > bump (only walking) > stay
    always @(*) begin
        case (state)
            // Walking states
            WALK_L, WALK_R: begin
                if (!ground) begin
                    // Start falling, same direction
                    next_state = (direction == 1'b0) ? FALL_L : FALL_R;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging, same direction
                    next_state = (direction == 1'b0) ? DIG_L : DIG_R;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // Change direction on bump
                    next_state = bumped_direction ? WALK_R : WALK_L;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue walking same direction
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            // Digging states
            DIG_L, DIG_R: begin
                if (!ground) begin
                    // Digging into hole, start falling
                    next_state = (direction == 1'b0) ? FALL_L : FALL_R;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            // Falling states
            FALL_L, FALL_R: begin
                if (ground) begin
                    if (fall_too_long) begin
                        // Splat, keep direction
                        next_state = (direction == 1'b0) ? SPLAT_L : SPLAT_R;
                        next_fall_timer = 5'd0;
                    end else begin
                        // Land safely, walk same direction
                        next_state = (direction == 1'b0) ? WALK_L : WALK_R;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Continue falling, increment timer
                    next_state = state;
                    next_fall_timer = fall_timer + 5'd1;
                end
            end

            // Splat states: terminal, remain here
            SPLAT_L, SPLAT_R: begin
                next_state = state;
                next_fall_timer = 5'd0;
            end

            default: begin
                // Defensive reset to walking left
                next_state = WALK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs: active only for non-splat states
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule