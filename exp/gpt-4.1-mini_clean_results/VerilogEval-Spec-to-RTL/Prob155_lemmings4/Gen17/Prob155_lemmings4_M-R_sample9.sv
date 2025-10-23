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

    // State encoding: each state encodes mode + direction
    typedef enum logic [3:0] {
        WALK_L  = 4'd0,
        WALK_R  = 4'd1,
        DIG_L   = 4'd2,
        DIG_R   = 4'd3,
        FALL_L  = 4'd4,
        FALL_R  = 4'd5,
        SPLAT   = 4'd6
    } state_t;

    state_t state, next_state;

    // fall_timer counts falling cycles; increment only in FALL states
    reg [4:0] fall_timer, next_fall_timer;

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Helper functions to get opposite direction state
    function state_t flip_dir(state_t s);
        case(s)
            WALK_L: flip_dir = WALK_R;
            WALK_R: flip_dir = WALK_L;
            DIG_L:  flip_dir = DIG_R;
            DIG_R:  flip_dir = DIG_L;
            FALL_L: flip_dir = FALL_R;
            FALL_R: flip_dir = FALL_L;
            default: flip_dir = s; // SPLAT or unknown remain
        endcase
    endfunction

    // Check if state is walking mode
    function logic is_walk(state_t s);
        is_walk = (s == WALK_L) || (s == WALK_R);
    endfunction

    // Check if state is digging mode
    function logic is_dig(state_t s);
        is_dig = (s == DIG_L) || (s == DIG_R);
    endfunction

    // Check if state is falling mode
    function logic is_fall(state_t s);
        is_fall = (s == FALL_L) || (s == FALL_R);
    endfunction

    // Check current direction: 0=left, 1=right
    function logic dir_of(state_t s);
        case(s)
            WALK_L, DIG_L, FALL_L: dir_of = 1'b0;
            WALK_R, DIG_R, FALL_R: dir_of = 1'b1;
            default: dir_of = 1'b0; // SPLAT default left (arbitrary)
        endcase
    endfunction

    // Next state logic with priority: fall > dig > bump/change dir
    always_comb begin
        next_state = state;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Remain SPLAT forever
                next_state = SPLAT;
                next_fall_timer = 0;
            end
            FALL_L, FALL_R: begin
                if (ground) begin
                    // Landed, check fall duration for splat
                    if (fall_timer > 20) begin
                        next_state = SPLAT;
                        next_fall_timer = 0;
                    end else begin
                        // Resume walking same direction
                        next_state = (state == FALL_L) ? WALK_L : WALK_R;
                        next_fall_timer = 0;
                    end
                end else begin
                    // Continue falling, increment fall_timer saturating at 31
                    next_state = state;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1;
                end
            end
            WALK_L, WALK_R: begin
                if (!ground) begin
                    // Ground gone -> start falling same direction
                    next_state = (state == WALK_L) ? FALL_L : FALL_R;
                    next_fall_timer = 1;
                end else if (dig) begin
                    // Start digging in current direction
                    next_state = (state == WALK_L) ? DIG_L : DIG_R;
                    next_fall_timer = 0;
                end else begin
                    // Walking on ground: bump can cause direction change
                    next_fall_timer = 0;
                    if (bump_both) begin
                        // Reverse direction
                        next_state = (state == WALK_L) ? WALK_R : WALK_L;
                    end else if (bump_left) begin
                        // Bumped left -> walk right
                        next_state = WALK_R;
                    end else if (bump_right) begin
                        // Bumped right -> walk left
                        next_state = WALK_L;
                    end else begin
                        // Keep walking same direction
                        next_state = state;
                    end
                end
            end
            DIG_L, DIG_R: begin
                if (!ground) begin
                    // Lost ground while digging -> fall in same direction
                    next_state = (state == DIG_L) ? FALL_L : FALL_R;
                    next_fall_timer = 1;
                end else begin
                    // Continue digging on ground
                    next_state = state;
                    next_fall_timer = 0;
                end
            end
            default: begin
                // Undefined state: reset to WALK_L as default safe state
                next_state = WALK_L;
                next_fall_timer = 0;
            end
        endcase
    end

    // Sequential logic: state and timer update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Outputs decoded from current state
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule