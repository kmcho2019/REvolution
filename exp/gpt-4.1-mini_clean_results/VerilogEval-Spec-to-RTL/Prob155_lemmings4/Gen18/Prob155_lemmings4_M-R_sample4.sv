module TopModule (
    input  logic clk,
    input  logic areset,       // asynchronous posedge reset
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    typedef enum logic [1:0] {
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    // State registers
    mode_t mode, next_mode;
    logic direction, next_direction;    // 0 = left, 1 = right
    logic [4:0] fall_timer, next_fall_timer;
    logic fall_too_long, next_fall_too_long;

    // Asynchronous reset and sequential update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;     // walk left
            fall_timer <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
            fall_too_long <= next_fall_too_long;
        end
    end

    // Combinational next-state logic
    always_comb begin
        // Default assignments to hold state
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;
        next_fall_too_long = 1'b0;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever; no outputs active
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
                next_fall_too_long = 1'b0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splatter if fell too long, else walk same direction
                    if (fall_too_long) begin
                        next_mode = MODE_SPLAT;
                    end else begin
                        next_mode = MODE_WALK;
                    end
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    next_direction = direction; // preserve direction
                end else begin
                    // Continue falling, increment timer
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = fall_timer + 5'd1;
                    // Once fall_too_long asserted, remain asserted
                    next_fall_too_long = fall_too_long | (fall_timer == 5'd20);
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Fall overrides dig and bump
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;      // start counting fall
                    next_fall_too_long = 1'b0;
                    next_direction = direction;  // preserve direction while falling
                end else if (dig) begin
                    // Digging only if on ground and walking
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end else begin
                    // Check bumps
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;

                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right) begin
                            // Both bumps switch direction
                            next_direction = ~direction;
                        end else if (bump_left) begin
                            next_direction = 1'b1; // walk right
                        end else begin
                            next_direction = 1'b0; // walk left
                        end
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // No ground during dig => start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end else begin
                    // Continue digging
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end
            end

            default: begin
                // Defensive reset to walking left on invalid mode
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
                next_fall_too_long = 1'b0;
            end
        endcase
    end

    // Moore outputs decoded from mode and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule