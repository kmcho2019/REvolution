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
        WLK_L = 3'b000,
        WLK_R = 3'b001,
        FALL_L = 3'b010,
        FALL_R = 3'b011,
        DIG_L = 3'b100,
        DIG_R = 3'b101,
        SPLAT = 3'b110
    } state_t;

    state_t state, next_state;

    // Fall duration counter (5 bits to count up to >20)
    logic [4:0] fall_count, next_fall_count;

    // Direction helper functions
    logic bumped;
    logic bump_any;
    logic bump_left_s;
    logic bump_right_s;

    assign bump_left_s = bump_left;
    assign bump_right_s = bump_right;
    assign bump_any = bump_left | bump_right;

    // Outputs as per state
    assign walk_left  = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);

    // Next state logic
    always_comb begin
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            SPLAT: begin
                // Once splatted, remain splatted
                next_state = SPLAT;
                next_fall_count = fall_count;
            end

            FALL_L, FALL_R: begin
                // Falling states
                if (ground) begin
                    // Ground hit, check fall duration for splatter
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 0;
                    end else begin
                        // Resume walking in same direction
                        next_state = (state == FALL_L) ? WLK_L : WLK_R;
                        next_fall_count = 0;
                    end
                end else begin
                    // Still falling, increment counter
                    next_state = state;
                    // Saturate counter at max 31 to avoid overflow
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1'b1;
                    else
                        next_fall_count = fall_count;
                end
            end

            WLK_L, WLK_R: begin
                // Walking states
                if (!ground) begin
                    // Ground disappeared, start falling (fall count reset)
                    next_state = (state == WLK_L) ? FALL_L : FALL_R;
                    next_fall_count = 0;
                end else if (dig) begin
                    // Start digging if dig=1 and on ground while walking
                    next_state = (state == WLK_L) ? DIG_L : DIG_R;
                    next_fall_count = 0;
                end else if (bump_any) begin
                    // Switch walking direction on bump
                    // Bumped on left or right or both: switch direction
                    if (state == WLK_L)
                        next_state = WLK_R;
                    else
                        next_state = WLK_L;
                    next_fall_count = 0;
                end else begin
                    // Continue walking same direction
                    next_state = state;
                    next_fall_count = 0;
                end
            end

            DIG_L, DIG_R: begin
                // Digging states
                if (!ground) begin
                    // Ground disappeared while digging: fall, keep direction
                    next_state = (state == DIG_L) ? FALL_L : FALL_R;
                    next_fall_count = 0;
                end else if (!dig) begin
                    // Stop digging and resume walking when dig=0 and still on ground
                    next_state = (state == DIG_L) ? WLK_L : WLK_R;
                    next_fall_count = 0;
                end else begin
                    // Continue digging
                    next_state = state;
                    next_fall_count = 0;
                end
            end

            default: begin
                // Safety fallback: reset to walk left on unknown state
                next_state = WLK_L;
                next_fall_count = 0;
            end
        endcase
    end

    // State and counter update with async reset (areset positive edge triggered async)
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;
            fall_count <= 0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end
endmodule