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

localparam [4:0] FALL_TIMER_MAX = 5'd20;

logic bump_any;
assign bump_any = bump_left | bump_right;

logic splat_condition;
assign splat_condition = (fall_timer > FALL_TIMER_MAX);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK;
        direction <= 1'b0; // walk left after reset
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        // Only update fall_timer when in FALL state, else zero
        if (state == FALL)
            fall_timer <= next_fall_timer;
        else
            fall_timer <= 5'd0;
    end
end

always_comb begin
    next_state = state;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case(state)
        SPLAT: begin
            next_state = SPLAT;
            next_fall_timer = 5'd0;
            next_direction = direction;
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
                next_direction = direction;
            end else begin
                next_state = FALL;
                // Saturate fall_timer at FALL_TIMER_MAX + some headroom
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                next_direction = direction;
            end
        end
        WALK: begin
            if (!ground) begin
                next_state = FALL;
                next_fall_timer = 5'd1; // start counting fall time
                next_direction = direction;
            end else if (dig) begin
                next_state = DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                next_state = WALK;
                next_fall_timer = 5'd0;
                // Simplify direction update: invert direction if any bump, set to right if bump left only, set to left if bump right only
                if (bump_left && bump_right)
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