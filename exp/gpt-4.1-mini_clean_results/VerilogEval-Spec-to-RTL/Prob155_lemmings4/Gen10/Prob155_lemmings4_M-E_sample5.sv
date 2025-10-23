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

// State encoding includes direction embedded in state
typedef enum logic [2:0] {
    ST_WALK_L  = 3'd0,
    ST_WALK_R  = 3'd1,
    ST_DIG_L   = 3'd2,
    ST_DIG_R   = 3'd3,
    ST_FALL_L  = 3'd4,
    ST_FALL_R  = 3'd5,
    ST_SPLAT   = 3'd6
} state_t;

state_t state, next_state;
logic [4:0] fall_timer, next_fall_timer; // fall timer saturating at 31

// Helper signals
logic direction_left; // direction 1=left,0=right (implicit in state)
logic falling;
logic digging_mode;
logic walking_mode;
logic splat;

// Decode outputs based on state
assign walk_left  = (state == ST_WALK_L);
assign walk_right = (state == ST_WALK_R);
assign digging    = (state == ST_DIG_L) || (state == ST_DIG_R);
assign aaah       = (state == ST_FALL_L) || (state == ST_FALL_R);

assign splat = (state == ST_SPLAT);

// Extract direction from state
always_comb begin
    case(state)
        ST_WALK_L, ST_DIG_L, ST_FALL_L: direction_left = 1'b1;
        ST_WALK_R, ST_DIG_R, ST_FALL_R: direction_left = 1'b0;
        default: direction_left = 1'b1; // default arbitrary
    endcase
end

// FSM sequential: state and fall_timer registers
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= ST_WALK_L;
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        fall_timer <= next_fall_timer;
    end
end

// FSM combinational next state and fall timer logic
always_comb begin
    next_state = state;
    next_fall_timer = fall_timer;

    // Default: no fall timer increment
    logic falling_now;
    falling_now = (state == ST_FALL_L) || (state == ST_FALL_R);

    // Helper to get opposite direction state
    function state_t toggle_direction(state_t s);
        case (s)
            ST_WALK_L: toggle_direction = ST_WALK_R;
            ST_WALK_R: toggle_direction = ST_WALK_L;
            ST_DIG_L:  toggle_direction = ST_DIG_R;
            ST_DIG_R:  toggle_direction = ST_DIG_L;
            ST_FALL_L: toggle_direction = ST_FALL_R;
            ST_FALL_R: toggle_direction = ST_FALL_L;
            default:   toggle_direction = s;
        endcase
    endfunction

    case(state)
        ST_SPLAT: begin
            // Stay splat forever, no timer increment
            next_state = ST_SPLAT;
            next_fall_timer = 5'd0;
        end

        ST_FALL_L, ST_FALL_R: begin
            if (ground) begin
                // Landed, check if splat
                if (fall_timer > 5'd20) begin
                    next_state = ST_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Resume walking in original direction (fall direction)
                    if (state == ST_FALL_L) next_state = ST_WALK_L;
                    else next_state = ST_WALK_R;
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Continue falling, increment fall timer saturating at 31
                next_state = state;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1;
            end
        end

        ST_WALK_L, ST_WALK_R: begin
            // Priority: fall > dig > bump
            if (!ground) begin
                // Start falling
                if (state == ST_WALK_L) next_state = ST_FALL_L;
                else next_state = ST_FALL_R;
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // Start digging only on ground and walking
                if (state == ST_WALK_L) next_state = ST_DIG_L;
                else next_state = ST_DIG_R;
                next_fall_timer = 5'd0;
            end else begin
                // Walking and bumped?
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    // Both bumps: toggle direction
                    next_state = toggle_direction(state);
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_state = ST_WALK_R;
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_state = ST_WALK_L;
                end else begin
                    // no bump, keep walking same direction
                    next_state = state;
                end
            end
        end

        ST_DIG_L, ST_DIG_R: begin
            if (!ground) begin
                // Fall while digging
                if (state == ST_DIG_L) next_state = ST_FALL_L;
                else next_state = ST_FALL_R;
                next_fall_timer = 5'd1;
            end else begin
                // Keep digging on ground ignoring bumps/dig inputs
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end

        default: begin
            // Safe default: walk left
            next_state = ST_WALK_L;
            next_fall_timer = 5'd0;
        end
    endcase
end

endmodule