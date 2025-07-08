module TopModule(
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
    typedef enum logic [1:0] {
        WLK_L = 2'b00,  // walking left
        WLK_R = 2'b01,  // walking right
        FALL  = 2'b10,  // falling
        DIGG  = 2'b11   // digging
    } state_t;

    state_t state, next_state;

    // Registers to remember walking direction before falling or digging
    // (only used for falling to resume direction, digging is directional inherently)
    // Actually, for digging we stay in original direction, so no change needed.
    // For falling, we must resume previous direction.
    state_t walk_dir;

    // State register with asynchronous posedge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;
            walk_dir <= WLK_L;  // walking left on reset
        end else begin
            state <= next_state;
            if ((state == WLK_L) || (state == WLK_R)) begin
                walk_dir <= state; // update walking direction only when walking
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            WLK_L: begin
                // Priority: fall > dig > bump
                if (ground == 0) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIGG;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WLK_R;
                end else begin
                    next_state = WLK_L;
                end
            end
            WLK_R: begin
                if (ground == 0) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIGG;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WLK_L;
                end else begin
                    next_state = WLK_R;
                end
            end
            FALL: begin
                // falling ignores bump and dig inputs
                // when ground appears, resume walking in previous direction
                if (ground == 1) begin
                    next_state = walk_dir;
                end else begin
                    next_state = FALL;
                end
            end
            DIGG: begin
                // When ground disappears, start falling
                if (ground == 0) begin
                    next_state = FALL;
                end else begin
                    // continue digging
                    next_state = DIGG;
                end
            end
            default: next_state = WLK_L;
        endcase
    end

    // Outputs: Moore machine outputs depend only on current state
    assign walk_left = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIGG);

endmodule