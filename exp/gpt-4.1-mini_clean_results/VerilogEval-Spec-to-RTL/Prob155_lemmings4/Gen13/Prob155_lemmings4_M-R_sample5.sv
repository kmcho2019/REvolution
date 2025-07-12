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

    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;
    logic direction, next_direction;
    logic [4:0] fall_timer, next_fall_timer;

    // Bump conditions
    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    wire splat_condition = (fall_timer > 5'd20);

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            state <= next_state;
        end
    end

    // Direction register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
        end else begin
            direction <= next_direction;
        end
    end

    // Fall timer register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            fall_timer <= 5'd0;
        end else begin
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic (only depends on current state, inputs, and fall timer)
    always_comb begin
        next_state = state;
        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
            end

            FALL: begin
                if (ground) begin
                    if (splat_condition)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                end else begin
                    next_state = FALL;
                end
            end

            DIG: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG;
            end

            WALK: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else
                    next_state = WALK;
            end

            default: next_state = WALK;
        endcase
    end

    // Next direction logic (only updated on WALK; otherwise stays the same)
    always_comb begin
        next_direction = direction; // default hold

        if (state == WALK) begin
            if (bump_both)
                next_direction = ~direction; // toggle
            else if (bump_left)
                next_direction = 1'b1;       // walk right
            else if (bump_right)
                next_direction = 1'b0;       // walk left
        end
    end

    // Next fall timer logic
    always_comb begin
        next_fall_timer = fall_timer; // default hold

        if (state == FALL) begin
            if (ground) begin
                // Reset timer on landing
                next_fall_timer = 5'd0;
            end else begin
                // Increment saturating at 31
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : (fall_timer + 1);
            end
        end else begin
            // Reset timer if not falling
            next_fall_timer = 5'd0;
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule