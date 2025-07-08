module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    typedef enum logic [2:0] {
        WL = 3'b000, // walking left
        WR = 3'b001, // walking right
        FALL = 3'b010,
        DIG_L = 3'b011,
        DIG_R = 3'b100
    } state_t;

    state_t state, next_state;

    // Async reset and state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WL;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        // Default next_state is current state
        next_state = state;

        case(state)
            WL: begin
                // Check fall first
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_L;
                end else if (bump_left || bump_right) begin
                    // Switch to walk right if bumped on either side
                    next_state = WR;
                end else begin
                    next_state = WL;
                end
            end

            WR: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bump_left || bump_right) begin
                    // Switch to walk left if bumped on either side
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end

            FALL: begin
                // If ground reappears, resume walking in previous direction
                if (ground) begin
                    // We must remember direction before falling. The only way to remember is from the state
                    // So we need to store direction in the FALL state. But since FALL is single state, direction info lost
                    // => Instead, FALL is a unique state, so we need to store the direction in a separate register
                    // We'll add a reg dir_walk: 0=left,1=right to hold walking direction

                    // This means changing design: add dir_walk reg updated on walking/digging states

                    // We'll fix this later in code. For now just placeholder.
                end
            end

            DIG_L: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG_L;
                end
            end

            DIG_R: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG_R;
                end
            end
        endcase
    end

    // We need a register to track walking direction for FALL state and output signals
    // direction = 0 left, 1 right
    logic dir_walk;

    // Update dir_walk on walking or digging states only, not falling
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            dir_walk <= 1'b0; // walking left
        end else begin
            // dir_walk updates only when in walking or digging states
            if (state == WL || state == DIG_L)
                dir_walk <= 1'b0;
            else if (state == WR || state == DIG_R)
                dir_walk <= 1'b1;
            // if falling, dir_walk unchanged
        end
    end

    // Now fix the FALL state transitions with dir_walk info
    always_comb begin
        case(state)
            FALL: begin
                if (ground) begin
                    // resume walking in dir_walk direction
                    if (dir_walk == 1'b0)
                        next_state = WL;
                    else
                        next_state = WR;
                end else begin
                    next_state = FALL;
                end
            end
            default: begin end
        endcase
    end

    // Outputs are Moore: depend only on current state
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_L) || (state == DIG_R);

endmodule