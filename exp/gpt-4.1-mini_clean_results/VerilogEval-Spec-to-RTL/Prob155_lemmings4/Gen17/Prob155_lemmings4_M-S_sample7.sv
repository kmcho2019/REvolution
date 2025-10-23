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
    // 000: Walk Left
    // 001: Walk Right
    // 010: Digging Left
    // 011: Digging Right
    // 100: Falling Left
    // 101: Falling Right
    // 110: Splat (final)
    typedef enum logic [2:0] {
        WL   = 3'd0,
        WR   = 3'd1,
        DL   = 3'd2,
        DR   = 3'd3,
        FL   = 3'd4,
        FR   = 3'd5,
        SPLAT= 3'd6
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer; // 5-bit counter for fall duration

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;
    wire splat_condition = (fall_timer > 5'd20);

    // Sequential logic with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL; // start walking left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and fall timer logic
    always_comb begin
        next_state = state;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end
            FL, FR: begin
                if (ground) begin
                    // Landed
                    if (splat_condition)
                        next_state = SPLAT;
                    else
                        next_state = (state == FL) ? WL : WR;
                    next_fall_timer = 5'd0;
                end else begin
                    // Keep falling, saturate at 31
                    next_state = state;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 5'd1;
                end
            end
            WL, WR: begin
                if (!ground) begin
                    // Start falling
                    next_state = (state == WL) ? FL : FR;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging if on ground and not falling
                    next_state = (state == WL) ? DL : DR;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // Change direction on bump
                    if (bump_both) begin
                        next_state = (state == WL) ? WR : WL;
                    end else if (bump_left) begin
                        next_state = WR; // bump left means walk right
                    end else if (bump_right) begin
                        next_state = WL; // bump right means walk left
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
            DL, DR: begin
                if (!ground) begin
                    // Start falling when ground disappears while digging
                    next_state = (state == DL) ? FL : FR;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging on ground
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end
            default: begin
                // Safe fallback
                next_state = WL;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs: Moore outputs from state only
    assign walk_left  = (state == WL);
    assign walk_right = (state == WR);
    assign digging    = (state == DL) || (state == DR);
    assign aaah       = (state == FL) || (state == FR);

endmodule