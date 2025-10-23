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

// State encoding for modes
typedef enum logic [1:0] {
    MODE_WALK  = 2'd0,
    MODE_DIG   = 2'd1,
    MODE_FALL  = 2'd2,
    MODE_SPLAT = 2'd3
} mode_t;

mode_t mode_reg, mode_next;
logic direction_reg, direction_next;  // 0 = left, 1 = right

logic [4:0] fall_timer_reg, fall_timer_next;

// State update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode_reg <= MODE_WALK;
        direction_reg <= 1'b0; // walk left initially
        fall_timer_reg <= 5'd0;
    end else begin
        mode_reg <= mode_next;
        direction_reg <= direction_next;
        fall_timer_reg <= fall_timer_next;
    end
end

// Next mode logic
always_comb begin
    mode_next = mode_reg;
    fall_timer_next = fall_timer_reg;
    direction_next = direction_reg;

    case (mode_reg)
        MODE_SPLAT: begin
            // Remain splatted forever, timer zero
            fall_timer_next = 5'd0;
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed
                if (fall_timer_reg > 5'd20) begin
                    mode_next = MODE_SPLAT;
                    fall_timer_next = 5'd0;
                end else begin
                    mode_next = MODE_WALK;
                    fall_timer_next = 5'd0;
                end
            end else begin
                // Continue falling
                mode_next = MODE_FALL;
                // fall_timer increments handled below
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                mode_next = MODE_FALL;
                fall_timer_next = 5'd1;
            end else if (dig) begin
                mode_next = MODE_DIG;
                fall_timer_next = 5'd0;
            end else begin
                mode_next = MODE_WALK;
                fall_timer_next = 5'd0;
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                mode_next = MODE_FALL;
                fall_timer_next = 5'd1;
            end else begin
                mode_next = MODE_DIG;
                fall_timer_next = 5'd0;
            end
        end

        default: begin
            mode_next = MODE_WALK;
            fall_timer_next = 5'd0;
        end
    endcase
end

// Fall timer increment logic (only when falling)
always_ff @(posedge clk) begin
    if (!areset) begin
        if (mode_reg == MODE_FALL && !ground) begin
            if (fall_timer_reg < 5'd21)
                fall_timer_reg <= fall_timer_reg + 5'd1;
            else
                fall_timer_reg <= fall_timer_reg;
        end else if (mode_reg != MODE_FALL) begin
            fall_timer_reg <= 5'd0;
        end
    end
end

// Next direction logic (only valid in walk mode, bumps ignored when falling or digging)
always_comb begin
    direction_next = direction_reg;

    if (mode_reg == MODE_WALK && ground && !dig) begin
        if (bump_left && bump_right) begin
            direction_next = ~direction_reg;
        end else if (bump_left) begin
            direction_next = 1'b1; // walk right
        end else if (bump_right) begin
            direction_next = 1'b0; // walk left
        end
    end
    // Else direction remains unchanged
end

// Outputs are Moore type: depend only on current mode and direction
assign walk_left  = (mode_reg == MODE_WALK) && (direction_reg == 1'b0);
assign walk_right = (mode_reg == MODE_WALK) && (direction_reg == 1'b1);
assign aaah       = (mode_reg == MODE_FALL);
assign digging    = (mode_reg == MODE_DIG);

endmodule