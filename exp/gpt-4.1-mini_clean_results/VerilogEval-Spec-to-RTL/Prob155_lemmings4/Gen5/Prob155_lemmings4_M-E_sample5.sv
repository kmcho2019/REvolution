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

// State encoding (3 bits):
// [2] Falling or splat (1 means falling/splat, 0 means walking/digging)
// [1] Direction: 0=left, 1=right
// [0] Mode: 0=walk, 1=dig if falling bit=0; if falling bit=1 and mode=1 then splat.
// States:
// 3'b000 = Walk Left
// 3'b001 = Dig Left
// 3'b010 = Walk Right
// 3'b011 = Dig Right
// 3'b100 = Fall Left
// 3'b110 = Fall Right
// 3'b101 = Splat Left (fall=1, direction=0, mode=1)
// 3'b111 = Splat Right (fall=1, direction=1, mode=1)

typedef enum logic [2:0] {
    WLK_L = 3'b000,
    DIG_L = 3'b001,
    WLK_R = 3'b010,
    DIG_R = 3'b011,
    FAL_L = 3'b100,
    SPL_L = 3'b101,
    FAL_R = 3'b110,
    SPL_R = 3'b111
} state_t;

state_t state, next_state;

logic [4:0] fall_timer, next_fall_timer;

// Async reset and state register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WLK_L;
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        fall_timer <= next_fall_timer;
    end
end

// Extract direction and mode helpers
wire direction = state[1]; // 0=left,1=right
wire is_falling = state[2] & ~state[0]; // fall states: bit2=1 and bit0=0
wire is_splat = (state == SPL_L) || (state == SPL_R);
wire is_digging = ~state[2] & state[0]; // bit2=0 & bit0=1
wire is_walking = ~state[2] & ~state[0]; // bit2=0 & bit0=0

// Next state logic
always_comb begin
    // Default next state and timer are current
    next_state = state;
    next_fall_timer = fall_timer;

    // If splatted, remain splatted
    if (is_splat) begin
        next_state = state;
        next_fall_timer = 5'd0;
    end else if (is_falling) begin
        // Falling state
        if (ground) begin
            // Landed
            if (fall_timer > 5'd20) begin
                // Splat
                next_state = (direction == 1'b0) ? SPL_L : SPL_R;
                next_fall_timer = 5'd0;
            end else begin
                // Back to walking same direction
                next_state = (direction == 1'b0) ? WLK_L : WLK_R;
                next_fall_timer = 5'd0;
            end
        end else begin
            // Continue falling, increment timer saturate at 31
            next_state = state;
            next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : fall_timer;
        end
    end else if (!ground) begin
        // Ground lost => falling state in current direction
        next_state = (direction == 1'b0) ? FAL_L : FAL_R;
        next_fall_timer = 5'd1;
    end else if (dig && is_walking) begin
        // Start digging if on ground and walking
        next_state = (direction == 1'b0) ? DIG_L : DIG_R;
        next_fall_timer = 5'd0;
    end else if (is_digging) begin
        // If ground lost during dig => fall (maintain direction)
        if (!ground) begin
            next_state = (direction == 1'b0) ? FAL_L : FAL_R;
            next_fall_timer = 5'd1;
        end else begin
            // Continue digging
            next_state = state;
            next_fall_timer = 5'd0;
        end
    end else begin
        // Walking on ground and not digging or falling: handle bumps
        // Bumps only affect walking states, not dig/fall/splat (already handled)
        // Only in walking states here
        if (bump_left && bump_right) begin
            // Switch direction
            next_state = (direction == 1'b0) ? WLK_R : WLK_L;
            next_fall_timer = 5'd0;
        end else if (bump_left) begin
            next_state = WLK_R;
            next_fall_timer = 5'd0;
        end else if (bump_right) begin
            next_state = WLK_L;
            next_fall_timer = 5'd0;
        end else begin
            next_state = state; // Remain walking same direction
            next_fall_timer = 5'd0;
        end
    end
end

// Outputs decode from state
assign walk_left  = (state == WLK_L);
assign walk_right = (state == WLK_R);
assign aaah       = is_falling;
assign digging    = is_digging;

endmodule