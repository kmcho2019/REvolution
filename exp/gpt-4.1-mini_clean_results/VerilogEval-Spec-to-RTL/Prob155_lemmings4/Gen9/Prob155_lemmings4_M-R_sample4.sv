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
logic [4:0] fall_timer, next_fall_timer; // 5-bit fall timer

// Internal signals
logic bumped; // Indicates bump on either side
logic bump_both;
logic splat_condition;

assign bump_both = bump_left & bump_right;
assign bumped = bump_left | bump_right;
assign splat_condition = (fall_timer > 5'd20);

// State update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK;
        direction <= 1'b0; // walk left after reset
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Next state and direction logic
always_comb begin
    // Default next values
    next_state = state;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case(state)
        SPLAT: begin
            // Remain splatted forever, timer reset
            next_state = SPLAT;
            next_fall_timer = 5'd0;
            // direction stays
        end
        FALL: begin
            if (ground) begin
                // Landed
                if (splat_condition) begin
                    next_state = SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                end
                // direction unchanged
                next_direction = direction;
            end else begin
                // Still falling: increment timer saturating at max 31
                next_state = FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end
        WALK: begin
            if (!ground) begin
                // Start falling
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging on ground
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bump-induced direction changes
                next_state = WALK;
                next_fall_timer = 5'd0;
                if (bump_both) begin
                    // Both bumps toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bumped on left -> walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bumped on right -> walk left
                    next_direction = 1'b0;
                end else begin
                    next_direction = direction;
                end
            end
        end
        DIG: begin
            if (!ground) begin
                // Ground gone, fall
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end
        default: begin
            // Failsafe reset to WALK left
            next_state = WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Output logic (Moore outputs depend on current state and direction)
assign walk_left  = (state == WALK) && (direction == 1'b0);
assign walk_right = (state == WALK) && (direction == 1'b1);
assign aaah       = (state == FALL);
assign digging    = (state == DIG);

endmodule