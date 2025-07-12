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
logic direction, next_direction; // 0=left, 1=right
logic [4:0] fall_timer, next_fall_timer;

logic splat_condition;
assign splat_condition = (fall_timer > 5'd20);

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

always_comb begin
    // Defaults
    next_state = state;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case(state)
        SPLAT: begin
            next_state = SPLAT;
            next_fall_timer = 5'd0;
            // direction unchanged
        end
        FALL: begin
            if (ground) begin
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
                next_state = FALL;
                // Increment timer only if below max to reduce toggling
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                next_direction = direction;
            end
        end
        WALK: begin
            if (!ground) begin
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                next_state = WALK;
                next_fall_timer = 5'd0;
                // Simplify direction update: if bump on both sides or either side, adjust direction accordingly
                if (bump_left & bump_right)
                    next_direction = ~direction;
                else if (bump_left)
                    next_direction = 1'b1;
                else if (bump_right)
                    next_direction = 1'b0;
                else
                    next_direction = direction;
            end
        end
        DIG: begin
            if (!ground) begin
                next_state = FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end
        default: begin
            next_state = WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

assign walk_left  = (state == WALK) && (direction == 1'b0);
assign walk_right = (state == WALK) && (direction == 1'b1);
assign aaah       = (state == FALL);
assign digging    = (state == DIG);

endmodule