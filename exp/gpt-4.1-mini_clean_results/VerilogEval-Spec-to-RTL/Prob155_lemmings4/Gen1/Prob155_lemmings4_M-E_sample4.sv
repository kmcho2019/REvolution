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

    // Mode encoding
    typedef enum logic [1:0] {
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3
    } mode_t;

    // Registers for mode, direction and fall timer
    mode_t mode, next_mode;
    logic direction, next_direction; // 0=left, 1=right
    logic [4:0] fall_timer, next_fall_timer; // counts fall cycles, max 31 for saturation

    // Asynchronous reset and state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            direction <= 1'b0; // left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always_comb begin
        // Default next state assignments
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            SPLAT: begin
                // Remain splattered forever until reset
                next_mode = SPLAT;
                next_direction = direction; // direction irrelevant
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Ground hit after fall
                    if (fall_timer > 5'd20) begin
                        // Splatter if fall was too long
                        next_mode = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        // Resume walking after safe fall
                        next_mode = WALK;
                        next_fall_timer = 5'd0;
                    end
                    // direction unchanged
                    next_direction = direction;
                end else begin
                    // Still falling, increment fall_timer saturating at 31
                    next_mode = FALL;
                    next_direction = direction;
                    if (fall_timer == 5'd31)
                        next_fall_timer = fall_timer;
                    else
                        next_fall_timer = fall_timer + 5'd1;
                end
            end

            WALK: begin
                if (ground == 1) begin
                    // On ground, check dig and bumps
                    if (dig) begin
                        // Start digging
                        next_mode = DIG;
                        next_fall_timer = 5'd0;
                        next_direction = direction;
                    end else if (bump_left || bump_right) begin
                        // Switch direction on any bump
                        next_direction = ~direction;
                        next_mode = WALK;
                        next_fall_timer = 5'd0;
                    end else begin
                        // Continue walking same direction
                        next_mode = WALK;
                        next_direction = direction;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // ground lost, start falling
                    next_mode = FALL;
                    next_direction = direction;
                    next_fall_timer = 5'd1; // falling starts at count 1
                end
            end

            DIG: begin
                if (ground == 0) begin
                    // Ground gone while digging, start falling
                    next_mode = FALL;
                    next_direction = direction;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging, ignore bumps and dig input
                    next_mode = DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Should never occur, reset to safe state
                next_mode = WALK;
                next_direction = 1'b0; // left
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs driven by registered state and direction
    assign walk_left = (mode == WALK) && (direction == 1'b0);
    assign walk_right = (mode == WALK) && (direction == 1'b1);
    assign aaah = (mode == FALL);
    assign digging = (mode == DIG);

endmodule