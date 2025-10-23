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

    // FSM states
    typedef enum logic [1:0] {
        WALKING = 2'd0,
        FALLING = 2'd1,
        DIGGING = 2'd2
    } state_t;

    state_t state, next_state;
    logic dir, next_dir; // 0 = left, 1 = right
    logic ground_d;      // delayed ground for edge detection

    // Asynchronous reset and state/direction registers
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0;    // start walking left
            ground_d <= 1'b1; // assume reset starts on ground
        end else begin
            state <= next_state;
            dir <= next_dir;
            ground_d <= ground;
        end
    end

    // Edge detection for ground
    wire ground_fell = (ground_d == 1'b1) && (ground == 1'b0); // ground lost this cycle
    wire ground_rise = (ground_d == 1'b0) && (ground == 1'b1); // ground gained this cycle

    // Any bump signal
    wire bump = bump_left | bump_right;

    // Next state and direction logic
    always_comb begin
        // Default assignments
        next_state = state;
        next_dir = dir;

        case(state)
            WALKING: begin
                // Priority: fall > dig > bump
                if (ground_fell) begin
                    // ground just lost: fall, keep dir
                    next_state = FALLING;
                    // dir unchanged
                end else if (!ground) begin
                    // ground gone, start falling (in case ground_fell missed)
                    next_state = FALLING;
                end else if (dig) begin
                    // dig command when walking on ground
                    next_state = DIGGING;
                end else if (bump && !ground_fell && !ground_rise) begin
                    // bump when walking on ground and no ground transition this cycle
                    next_dir = ~dir; // switch direction
                    next_state = WALKING;
                end else begin
                    // remain walking same direction
                    next_state = WALKING;
                end
            end

            FALLING: begin
                if (ground_rise) begin
                    // landed on ground: resume walking in stored direction
                    next_state = WALKING;
                    // dir unchanged
                end else if (ground == 0) begin
                    // still falling
                    next_state = FALLING;
                end else begin
                    // Defensive: if ground stable and no rise, remain falling
                    next_state = FALLING;
                end
                // bumps ignored while falling: direction unchanged
            end

            DIGGING: begin
                if (!ground) begin
                    // hit edge: start falling, keep direction
                    next_state = FALLING;
                end else begin
                    // continue digging
                    next_state = DIGGING;
                end
                // bumps ignored while digging: direction unchanged
            end

            default: begin
                // Should not happen: reset state and direction
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs depend only on state and direction (Moore FSM)
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule