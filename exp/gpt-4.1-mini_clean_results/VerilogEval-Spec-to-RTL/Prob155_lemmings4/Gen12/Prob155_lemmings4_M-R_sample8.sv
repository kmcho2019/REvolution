module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    typedef enum logic [1:0] {
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    mode_t state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;
    reg fall_too_long, next_fall_too_long;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= MODE_WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
            fall_too_long <= next_fall_too_long;
        end
    end

    // Next state logic and outputs combinational block
    always @(*) begin
        // Defaults
        next_state = state;
        next_direction = direction;
        next_fall_timer = 5'd0;
        next_fall_too_long = 1'b0;

        // Default outputs
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            MODE_WALK: begin
                walk_left = (direction == 1'b0);
                walk_right = (direction == 1'b1);
                if (!ground) begin
                    next_state = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    // direction unchanged
                end else if (dig) begin
                    next_state = MODE_DIG;
                    // direction unchanged
                end else begin
                    // Switch direction if bumped (if bump on either side)
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right) begin
                            next_direction = ~direction;
                        end else if (bump_left) begin
                            next_direction = 1'b1; // walk right
                        end else begin
                            next_direction = 1'b0; // walk left
                        end
                    end
                end
            end

            MODE_DIG: begin
                digging = 1'b1;
                // continue digging while ground present
                if (!ground) begin
                    // fall after digging off ledge
                    next_state = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    // direction unchanged
                end
            end

            MODE_FALL: begin
                aaah = 1'b1;
                if (ground) begin
                    // landed
                    if (fall_too_long)
                        next_state = MODE_SPLAT;
                    else
                        next_state = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    // direction unchanged
                end else begin
                    // increment fall timer
                    next_state = MODE_FALL;
                    next_fall_timer = fall_timer + 1'b1;
                    next_fall_too_long = fall_too_long | (fall_timer == 5'd20);
                    // direction unchanged
                end
            end

            MODE_SPLAT: begin
                // all outputs zero, no state changes
                // next_state and other regs remain same
            end

            default: begin
                // Defensive fallback to walk left
                next_state = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
                next_fall_too_long = 1'b0;
            end
        endcase
    end

endmodule