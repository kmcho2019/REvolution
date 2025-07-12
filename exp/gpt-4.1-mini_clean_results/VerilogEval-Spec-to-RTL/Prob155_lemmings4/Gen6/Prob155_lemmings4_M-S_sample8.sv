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
    // 000: WALK_LEFT
    // 001: WALK_RIGHT
    // 010: DIG_LEFT
    // 011: DIG_RIGHT
    // 100: FALL_LEFT
    // 101: FALL_RIGHT
    // 110: SPLAT (direction irrelevant)
    // 111: unused (treat as SPLAT)

    localparam WALK_L = 3'd0,
               WALK_R = 3'd1,
               DIG_L  = 3'd2,
               DIG_R  = 3'd3,
               FALL_L = 3'd4,
               FALL_R = 3'd5,
               SPLAT  = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and timer logic
    always @(*) begin
        next_state = state;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL_L, FALL_R: begin
                if (ground) begin
                    // Landed, check for splatter
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        // Resume walking in same direction
                        next_state = (state == FALL_L) ? WALK_L : WALK_R;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Continue falling, increment saturating timer
                    next_state = state;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : 5'd31;
                end
            end

            WALK_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = DIG_L;
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    // Bump logic: toggle direction if both, else walk opposite side
                    if (bump_left && bump_right) next_state = WALK_R;
                    else if (bump_left)          next_state = WALK_R;
                    else                        next_state = WALK_L; // bump_right only: walk left again = stay same
                end else begin
                    next_state = WALK_L;
                    next_fall_timer = 5'd0;
                end
            end

            WALK_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = DIG_R;
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    if (bump_left && bump_right) next_state = WALK_L;
                    else if (bump_left)          next_state = WALK_R; // bump_left only: walk right again = stay same
                    else                        next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                    next_fall_timer = 5'd0;
                end
            end

            DIG_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                    next_fall_timer = 5'd1;
                end else begin
                    next_state = DIG_L;
                    next_fall_timer = 5'd0;
                end
            end

            DIG_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                    next_fall_timer = 5'd1;
                end else begin
                    next_state = DIG_R;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Safety fallback to walk left
                next_state = WALK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs from state
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule