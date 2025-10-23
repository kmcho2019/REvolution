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

    // State encoding with typedef enum for clarity
    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;
    logic direction, next_direction; // 0=left, 1=right
    logic [4:0] fall_timer, next_fall_timer; // 5-bit counter for falling time

    // Intermediate signals for bump handling
    logic bump_any = bump_left | bump_right;
    logic bump_both = bump_left & bump_right;

    // Condition for splat: fall_timer > 20
    logic splat_condition;

    assign splat_condition = (fall_timer > 5'd20);

    // Sequential state, direction, and timer update with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational logic for next state, direction, fall_timer
    always_comb begin
        // Defaults: hold current values
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Forever splatted: no outputs, timer reset
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
            FALL: begin
                if (ground) begin
                    // Landed: check for splat
                    if (splat_condition) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = WALK;
                        next_fall_timer = 5'd0;
                    end
                    next_direction = direction; // direction preserved
                end else begin
                    // Still falling: increment timer saturating at 31
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                end
            end
            WALK: begin
                if (!ground) begin
                    // Start falling immediately
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging if on ground and not falling
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Stay walking; handle bumps with priority:
                    // bump_both toggles direction,
                    // else bump_left walks right,
                    // else bump_right walks left,
                    // else keep direction.
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    if (bump_both)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else if (bump_right)
                        next_direction = 1'b0; // walk left
                    else
                        next_direction = direction;
                end
            end
            DIG: begin
                if (!ground) begin
                    // Lost ground while digging -> fall
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging on ground
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end
            default: begin
                // Safety fallback to WALK left
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs are purely combinational Moore style
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule