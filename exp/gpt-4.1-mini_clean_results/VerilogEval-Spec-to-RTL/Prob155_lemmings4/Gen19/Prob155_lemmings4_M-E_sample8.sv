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

    // Define combined state encoding with direction embedded
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        DIG_LEFT   = 3'd2,
        DIG_RIGHT  = 3'd3,
        FALL_LEFT  = 3'd4,
        FALL_RIGHT = 3'd5,
        SPLAT      = 3'd6
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer; // saturate at 21

    // Async reset on posedge areset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and fall_timer combinational logic
    always_comb begin
        next_state = state;
        next_fall_timer = 5'd0;

        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // Landed: check fall duration
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        // Resume walking in same direction
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Keep falling, increment timer saturating at 21
                    next_state = state;
                    next_fall_timer = (fall_timer < 5'd21) ? fall_timer + 1 : 5'd21;
                end
            end

            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // Switch direction on any bump (including both)
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                    next_fall_timer = 5'd1;
                end
                // Else continue digging left
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end
                // Else continue digging right
            end

            default: begin
                // Defensive: reset to walk left if undefined
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore output decoding
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule