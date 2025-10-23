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
typedef enum logic [2:0] {
    WLK_L = 3'd0,
    WLK_R = 3'd1,
    DIG_L = 3'd2,
    DIG_R = 3'd3,
    FALL_L = 3'd4,
    FALL_R = 3'd5,
    SPLAT  = 3'd6
} state_t;

state_t state, next_state;

// Fall timer: counts how many cycles Lemming has been falling
logic [4:0] fall_timer, next_fall_timer; // 5 bits to count up to >20

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

// Next state logic and next fall timer
always_comb begin
    // Defaults
    next_state = state;
    next_fall_timer = fall_timer;

    case (state)
        SPLAT: begin
            // Remain splattered forever until reset
            next_state = SPLAT;
            next_fall_timer = 5'd0;
        end

        // Walking left state
        WLK_L: begin
            if (ground == 0) begin
                // Start falling facing left, reset fall timer to 1
                next_state = FALL_L;
                next_fall_timer = 5'd1;
            end else if (dig == 1) begin
                // Start digging facing left
                next_state = DIG_L;
                next_fall_timer = 5'd0;
            end else if (bump_left || bump_right) begin
                // Switch direction to right
                next_state = WLK_R;
                next_fall_timer = 5'd0;
            end else begin
                // Continue walking left
                next_state = WLK_L;
                next_fall_timer = 5'd0;
            end
        end

        // Walking right state
        WLK_R: begin
            if (ground == 0) begin
                next_state = FALL_R;
                next_fall_timer = 5'd1;
            end else if (dig == 1) begin
                next_state = DIG_R;
                next_fall_timer = 5'd0;
            end else if (bump_left || bump_right) begin
                // Switch direction to left
                next_state = WLK_L;
                next_fall_timer = 5'd0;
            end else begin
                next_state = WLK_R;
                next_fall_timer = 5'd0;
            end
        end

        // Digging left state
        DIG_L: begin
            if (ground == 0) begin
                // Fall when ground disappears while digging, keep direction left
                next_state = FALL_L;
                next_fall_timer = 5'd1;
            end else begin
                // Continue digging left (ignores bumps and dig input while digging)
                next_state = DIG_L;
                next_fall_timer = 5'd0;
            end
        end

        // Digging right state
        DIG_R: begin
            if (ground == 0) begin
                next_state = FALL_R;
                next_fall_timer = 5'd1;
            end else begin
                next_state = DIG_R;
                next_fall_timer = 5'd0;
            end
        end

        // Falling left state
        FALL_L: begin
            if (ground == 1) begin
                // If fall_timer > 20, splatter
                if (fall_timer > 5'd20) begin
                    next_state = SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Resume walking left after fall
                    next_state = WLK_L;
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Still falling, increment timer
                next_state = FALL_L;
                if (fall_timer == 5'h1F)
                    next_fall_timer = fall_timer; // saturate at max 31
                else
                    next_fall_timer = fall_timer + 5'd1;
            end
        end

        // Falling right state
        FALL_R: begin
            if (ground == 1) begin
                if (fall_timer > 5'd20) begin
                    next_state = SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = WLK_R;
                    next_fall_timer = 5'd0;
                end
            end else begin
                next_state = FALL_R;
                if (fall_timer == 5'h1F)
                    next_fall_timer = fall_timer;
                else
                    next_fall_timer = fall_timer + 5'd1;
            end
        end

        default: begin
            // Unknown state: reset to walking left (safe)
            next_state = WLK_L;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Moore outputs depending on state
assign walk_left = (state == WLK_L);
assign walk_right = (state == WLK_R);
assign aaah = (state == FALL_L) || (state == FALL_R);
assign digging = (state == DIG_L) || (state == DIG_R);

endmodule