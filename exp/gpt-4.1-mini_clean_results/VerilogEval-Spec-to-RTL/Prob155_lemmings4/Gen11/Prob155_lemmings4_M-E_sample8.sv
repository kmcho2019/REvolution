module TopModule (
    input  clk,
    input  areset,       // async posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding (5 states)
    localparam STATE_WALK_LEFT  = 5'b00001;
    localparam STATE_WALK_RIGHT = 5'b00010;
    localparam STATE_FALL       = 5'b00100;
    localparam STATE_DIG        = 5'b01000;
    localparam STATE_SPLAT      = 5'b10000;

    reg [4:0] state, next_state;

    // Fall duration timer: 5 bits, saturates at 31
    reg [4:0] fall_timer, next_fall_timer;

    // Helper signals for bumps
    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;

    // Asynchronous reset and state/timer registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state and fall_timer logic
    always @(*) begin
        next_state = state;
        next_fall_timer = fall_timer;

        case (state)
            STATE_SPLAT: begin
                // Terminal state: remain splatted forever, timer 0
                next_state = STATE_SPLAT;
                next_fall_timer = 5'd0;
            end

            STATE_FALL: begin
                if (ground) begin
                    // Landed: splatter if fallen > 20, else resume walking direction before fall
                    if (fall_timer > 5'd20)
                        next_state = STATE_SPLAT;
                    else begin
                        // We need to resume walking in the same direction as before fall.
                        // The direction before fall was the last walking state before fall
                        // but we only have current state FALL now. To recall direction, we track
                        // it by latching direction in walking states.
                        // Since direction is encoded in walk states, we must store it separately
                        // or infer it from previous state.
                        // Instead, we'll store direction as a reg updated on walking states.
                        // Let's do that below (direction reg).
                        // For now, stay FALL in case direction unknown
                        // (We'll add a reg 'direction' to track walking direction.)
                    end
                    next_fall_timer = 5'd0;
                end else begin
                    // Still falling: increment timer saturated at 31
                    next_state = STATE_FALL;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : 5'd31;
                end
            end

            STATE_WALK_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = STATE_DIG;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // bump switches direction
                    next_state = STATE_WALK_RIGHT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = STATE_WALK_LEFT;
                    next_fall_timer = 5'd0;
                end
            end

            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = STATE_DIG;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // bump switches direction
                    next_state = STATE_WALK_LEFT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                    next_fall_timer = 5'd0;
                end
            end

            STATE_DIG: begin
                if (!ground) begin
                    // Digging and ground gone: fall starts
                    next_state = STATE_FALL;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_state = STATE_DIG;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Safety default to walk left
                next_state = STATE_WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // We must handle direction persistence after fall:
    // Direction is encoded in walking states, but when falling or digging,
    // we must remember the direction to resume walking correctly.
    // To do that, track a direction register updated only when in walk states.

    reg dir_reg, next_dir_reg; // 0=left, 1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir_reg <= 1'b0; // start walking left
        end else begin
            dir_reg <= next_dir_reg;
        end
    end

    always @(*) begin
        next_dir_reg = dir_reg;

        // Update direction only when in walk states (not fall/dig/splat)
        if (state == STATE_WALK_LEFT)
            next_dir_reg = 1'b0;
        else if (state == STATE_WALK_RIGHT)
            next_dir_reg = 1'b1;
        else
            next_dir_reg = dir_reg;
    end

    // We use dir_reg to determine which walking state to enter after falling:
    // So, amend next_state FSM to handle landing from falling with direction restoring.

    always @(*) begin
        // Override next_state on falling land with direction restore or splat
        if (state == STATE_FALL && ground) begin
            if (fall_timer > 5'd20) begin
                next_state = STATE_SPLAT;
            end else begin
                // Resume walking in remembered direction
                if (dir_reg == 1'b0)
                    next_state = STATE_WALK_LEFT;
                else
                    next_state = STATE_WALK_RIGHT;
            end
            next_fall_timer = 5'd0;
        end
    end

    // Outputs are Moore: depend only on current state
    assign walk_left  = (state == STATE_WALK_LEFT);
    assign walk_right = (state == STATE_WALK_RIGHT);
    assign aaah       = (state == STATE_FALL);
    assign digging    = (state == STATE_DIG);

endmodule