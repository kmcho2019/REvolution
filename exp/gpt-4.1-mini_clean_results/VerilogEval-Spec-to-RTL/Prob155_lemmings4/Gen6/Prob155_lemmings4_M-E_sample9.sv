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

// State encoding: 3 bits used, 8 states total
localparam 
    WALK_L = 3'd0,
    WALK_R = 3'd1,
    DIG_L  = 3'd2,
    DIG_R  = 3'd3,
    FALL_L = 3'd4,
    FALL_R = 3'd5,
    SPLAT  = 3'd6;

// State register
reg [2:0] state, next_state;

// Fall timer (5 bits), counts up to 31 saturation
reg [4:0] fall_timer, next_fall_timer;

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_L;
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        fall_timer <= next_fall_timer;
    end
end

// Helper functions for direction and activity queries
wire is_walk = (state == WALK_L) || (state == WALK_R);
wire is_dig  = (state == DIG_L)  || (state == DIG_R);
wire is_fall = (state == FALL_L) || (state == FALL_R);
wire is_splat= (state == SPLAT);
wire dir_left = (state == WALK_L) || (state == DIG_L) || (state == FALL_L);
wire dir_right= (state == WALK_R) || (state == DIG_R) || (state == FALL_R);

always @* begin
    // Defaults keep current state and timer (except fall timer 0 if not falling)
    next_state = state;
    next_fall_timer = is_fall ? fall_timer : 5'd0;

    case(state)
        SPLAT: begin
            // Once splatted, remain forever
            next_state = SPLAT;
            next_fall_timer = 5'd0;
        end

        FALL_L, FALL_R: begin
            if (ground) begin
                // Landing: check fall duration
                if (fall_timer > 5'd20) begin
                    next_state = SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Resume walking in same direction
                    next_state = (state == FALL_L) ? WALK_L : WALK_R;
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Keep falling, increment fall timer saturating at 31
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 5'd1;
                else
                    next_fall_timer = fall_timer;
                next_state = state;
            end
        end

        WALK_L, WALK_R: begin
            if (!ground) begin
                // Ground lost: start falling in current direction, timer=1
                next_state = (state == WALK_L) ? FALL_L : FALL_R;
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // Start digging on ground if dig=1
                next_state = (state == WALK_L) ? DIG_L : DIG_R;
                next_fall_timer = 5'd0;
            end else if (bump_left || bump_right) begin
                // Handle bumps on walking states only
                // bump_left=1 & bump_right=0 => walk right
                // bump_right=1 & bump_left=0 => walk left
                // both bump_left & bump_right=1 => toggle direction
                if (bump_left && bump_right) begin
                    next_state = (state == WALK_L) ? WALK_R : WALK_L;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = state; // no change
                end
                next_fall_timer = 5'd0;
            end else begin
                // Continue walking same direction
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end

        DIG_L, DIG_R: begin
            if (!ground) begin
                // Lost ground while digging: start falling with same direction, timer=1
                next_state = (state == DIG_L) ? FALL_L : FALL_R;
                next_fall_timer = 5'd1;
            end else begin
                // Continue digging on ground regardless of dig signal
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end

        default: begin
            // Invalid states -> reset to WALK_L
            next_state = WALK_L;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Moore outputs based on current state
assign walk_left  = (state == WALK_L);
assign walk_right = (state == WALK_R);
assign aaah       = is_fall;
assign digging    = is_dig;

endmodule