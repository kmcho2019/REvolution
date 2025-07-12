module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding with embedded direction bit for walk/dig:
    // bit2..1: main state, bit0: direction (0=left,1=right) if applicable
    // 000: WALK left
    // 001: WALK right
    // 010: DIG left
    // 011: DIG right
    // 100: FALL (direction stored separately)
    // 101: SPLAT (direction irrelevant)
    typedef enum logic [2:0] {
        WALK_L = 3'b000,
        WALK_R = 3'b001,
        DIG_L  = 3'b010,
        DIG_R  = 3'b011,
        FALL   = 3'b100,
        SPLAT  = 3'b101
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer;
    logic direction_fall; // store direction during fall to restore after landing

    wire fall_too_long = (fall_timer > 5'd20);
    wire bump = bump_left | bump_right;

    // Asynchronous posedge reset, sequential update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK_L;
            direction_fall <= 1'b0; // left by default
            fall_timer  <= 5'd0;
        end else begin
            state       <= next_state;
            direction_fall <= (state == FALL) ? direction_fall : ( (state == WALK_L || state == DIG_L) ? 1'b0 : (state == WALK_R || state == DIG_R) ? 1'b1 : direction_fall );
            fall_timer  <= next_fall_timer;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Remain splatted forever
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed: splat if fell too long, else resume walking in saved direction
                    if (fall_too_long)
                        next_state = SPLAT;
                    else
                        next_state = direction_fall ? WALK_R : WALK_L;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue falling, increment timer saturating at 31
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                end
            end

            DIG_L, DIG_R: begin
                // If no ground, start falling with direction saved
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_fall_timer = 5'd0;
                end
            end

            WALK_L, WALK_R: begin
                if (!ground) begin
                    // Start falling with direction saved
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging, keep direction
                    next_state = (state == WALK_L) ? DIG_L : DIG_R;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // Switch direction on any bump (both or one side)
                    next_state = (state == WALK_L) ? WALK_R : WALK_L;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue walking same direction
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Defensive fallback to WALK_L
                next_state = WALK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL);

endmodule