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

// State encoding
typedef enum logic [1:0] {
    WALK  = 2'b00,
    DIG   = 2'b01,
    FALL  = 2'b10,
    SPLAT = 2'b11
} state_t;

typedef enum logic {
    LEFT  = 1'b0,
    RIGHT = 1'b1
} direction_t;

state_t state, next_state;
direction_t direction, next_direction;

logic [4:0] fall_timer, next_fall_timer;

// Bump signals
logic bump_any = bump_left | bump_right;
logic bump_both = bump_left & bump_right;
logic splat_condition;

// Sequential logic for state, direction, fall_timer updates
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state      <= WALK;
        direction  <= LEFT;
        fall_timer <= 5'd0;
    end else begin
        state      <= next_state;
        direction  <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Combinational logic for next_state, next_direction, next_fall_timer
always_comb begin
    // Default assignments: hold current state
    next_state      = state;
    next_direction  = direction;
    next_fall_timer = fall_timer;

    splat_condition = (fall_timer > 5'd20);

    case (state)
        SPLAT: begin
            // Remain splatted forever; no changes
            next_state      = SPLAT;
            next_fall_timer = 5'd0;
            // direction unchanged
        end

        FALL: begin
            if (ground) begin
                if (splat_condition) begin
                    next_state = SPLAT;
                end else begin
                    next_state = WALK;
                end
                next_fall_timer = 5'd0;
                // direction unchanged
                next_direction = direction;
            end else begin
                // Continue falling, increment timer saturating at 31
                next_state = FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end

        DIG: begin
            if (!ground) begin
                // Ground disappeared, start falling
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

        WALK: begin
            if (!ground) begin
                // Start falling
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bumps with priority
                next_state = WALK;
                next_fall_timer = 5'd0;
                if (bump_both) begin
                    // Both sides bumped - toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bumped left - walk right
                    next_direction = RIGHT;
                end else if (bump_right) begin
                    // Bumped right - walk left
                    next_direction = LEFT;
                end else begin
                    next_direction = direction;
                end
            end
        end

        default: begin
            // Safe fallback
            next_state = WALK;
            next_direction = LEFT;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Output logic (Moore outputs)
assign walk_left  = (state == WALK) && (direction == LEFT);
assign walk_right = (state == WALK) && (direction == RIGHT);
assign aaah       = (state == FALL);
assign digging    = (state == DIG);

endmodule