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
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    mode_t mode_reg, mode_next;
    logic direction_reg, direction_next; // 0=left, 1=right
    logic [4:0] fall_timer_reg, fall_timer_next;

    // Asynchronous reset and synchronous updates
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode_reg <= MODE_WALK;
            direction_reg <= 1'b0; // walk left
            fall_timer_reg <= 5'd0;
        end else begin
            mode_reg <= mode_next;
            direction_reg <= direction_next;
            fall_timer_reg <= fall_timer_next;
        end
    end

    // Combinational next-state logic
    always_comb begin
        // Default assignments to hold current values
        mode_next = mode_reg;
        direction_next = direction_reg;
        fall_timer_next = fall_timer_reg;

        case (mode_reg)
            MODE_SPLAT: begin
                // Splat stays forever, all outputs 0
                mode_next = MODE_SPLAT;
                direction_next = direction_reg;
                fall_timer_next = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed on ground
                    if (fall_timer_reg > 5'd20) begin
                        // Too long fall => splat
                        mode_next = MODE_SPLAT;
                        fall_timer_next = 5'd0;
                        direction_next = direction_reg; // direction kept, but irrelevant in splat
                    end else begin
                        // Resume walking same direction
                        mode_next = MODE_WALK;
                        fall_timer_next = 5'd0;
                        direction_next = direction_reg;
                    end
                end else begin
                    // Keep falling, increment timer saturating at 21
                    mode_next = MODE_FALL;
                    direction_next = direction_reg;
                    if (fall_timer_reg < 5'd21)
                        fall_timer_next = fall_timer_reg + 5'd1;
                    else
                        fall_timer_next = fall_timer_reg;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Ground gone, start falling
                    mode_next = MODE_FALL;
                    direction_next = direction_reg;
                    fall_timer_next = 5'd1;
                end else if (dig) begin
                    // Start digging if dig requested
                    mode_next = MODE_DIG;
                    direction_next = direction_reg;
                    fall_timer_next = 5'd0;
                end else begin
                    // Handle bumps and direction changes
                    mode_next = MODE_WALK;
                    fall_timer_next = 5'd0;

                    if (bump_left && bump_right) begin
                        // Both bumps flip direction
                        direction_next = ~direction_reg;
                    end else if (bump_left) begin
                        direction_next = 1'b1; // walk right
                    end else if (bump_right) begin
                        direction_next = 1'b0; // walk left
                    end else begin
                        direction_next = direction_reg;
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Lose ground while digging: start falling
                    mode_next = MODE_FALL;
                    fall_timer_next = 5'd1;
                    direction_next = direction_reg;
                end else begin
                    // Continue digging
                    mode_next = MODE_DIG;
                    direction_next = direction_reg;
                    fall_timer_next = 5'd0;
                end
            end

            default: begin
                mode_next = MODE_WALK;
                direction_next = 1'b0; // walk left default
                fall_timer_next = 5'd0;
            end
        endcase
    end

    // Output logic: Moore machine outputs depend on registered state
    assign walk_left  = (mode_reg == MODE_WALK) && (direction_reg == 1'b0);
    assign walk_right = (mode_reg == MODE_WALK) && (direction_reg == 1'b1);
    assign aaah       = (mode_reg == MODE_FALL);
    assign digging    = (mode_reg == MODE_DIG);

endmodule