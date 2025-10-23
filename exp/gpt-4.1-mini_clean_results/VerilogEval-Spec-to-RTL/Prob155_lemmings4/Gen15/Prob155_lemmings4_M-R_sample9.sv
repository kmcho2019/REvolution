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

    // One-hot state encoding
    typedef enum logic [3:0] {
        WALK_L = 4'b0001,
        WALK_R = 4'b0010,
        DIG_L  = 4'b0100,
        DIG_R  = 4'b1000,
        FALL   = 4'b10000,  // We'll handle fall separately with one bit, not one-hot due to directions
        SPLAT  = 4'b0       // SPLAT treated with separate bit below since we have direction bits in walking/digging states
    } state_oh_t;

    // Since we must keep direction and multiple states, let's simplify:
    // Use states as: WALK, DIG, FALL, SPLAT, with direction bit stored separately.
    typedef enum logic [1:0] {
        ST_WALK = 2'b00,
        ST_DIG  = 2'b01,
        ST_FALL = 2'b10,
        ST_SPLAT= 2'b11
    } state_t;

    state_t state, next_state;

    // Direction: 0=left, 1=right
    logic direction, next_direction;

    // Fall timer: 5 bits, increments only in FALL, saturates at 31
    logic [4:0] fall_timer;
    logic fall_timer_en;
    logic [4:0] next_fall_timer;

    // Derive fall_too_long combinationally
    wire fall_too_long = (fall_timer > 5'd20);

    // Asynchronous posedge reset for state and direction
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= ST_WALK;
            direction <= 1'b0;       // walk left on reset
            fall_timer<= 5'd0;
        end else begin
            state     <= next_state;
            direction <= next_direction;
            fall_timer<= next_fall_timer;
        end
    end

    // Update fall timer with enable and saturation
    always_comb begin
        if (fall_timer_en) begin
            if (fall_timer == 5'd31)
                next_fall_timer = 5'd31;
            else
                next_fall_timer = fall_timer + 1'b1;
        end else begin
            next_fall_timer = 5'd0;
        end
    end

    // Determine next state (except direction) based on priority fall>dig>bump
    always_comb begin
        next_state = state;

        case (state)
            ST_SPLAT: begin
                next_state = ST_SPLAT; // stuck forever
            end
            ST_FALL: begin
                if (ground) begin
                    if (fall_too_long)
                        next_state = ST_SPLAT;
                    else
                        next_state = ST_WALK;
                end else begin
                    next_state = ST_FALL;
                end
            end
            ST_DIG: begin
                if (!ground)
                    next_state = ST_FALL;
                else
                    next_state = ST_DIG;
            end
            ST_WALK: begin
                if (!ground)
                    next_state = ST_FALL;
                else if (dig)
                    next_state = ST_DIG;
                else
                    next_state = ST_WALK;
            end
            default: next_state = ST_WALK;
        endcase
    end

    // Enable fall_timer increment only when in FALL and not splatted
    assign fall_timer_en = (state == ST_FALL);

    // Update direction only when walking and bumped, otherwise hold
    // Bumps have no effect in other states
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // left on reset
        end else if (state == ST_WALK) begin
            // Bump handling same as before but simplified
            if (bump_left && bump_right)
                direction <= ~direction;
            else if (bump_left)
                direction <= 1'b1; // walk right
            else if (bump_right)
                direction <= 1'b0; // walk left
            else
                direction <= direction; // no change
        end else begin
            direction <= direction; // hold direction in DIG, FALL, SPLAT
        end
    end

    // Moore outputs assigned continuously
    assign walk_left  = (state == ST_WALK) && (direction == 1'b0);
    assign walk_right = (state == ST_WALK) && (direction == 1'b1);
    assign digging    = (state == ST_DIG);
    assign aaah       = (state == ST_FALL);

endmodule