module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALL = 2'b10,
        DIG = 2'b11
    } state_t;

    state_t state, next_state;

    // To remember walking direction before fall or dig
    state_t last_walk_dir;

    // Combinational next-state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Priority: fall > dig > bump switch direction

        // If falling currently
        if (state == FALL) begin
            if (ground) begin
                // Ground back, resume walking in last direction
                next_state = last_walk_dir;
            end else begin
                // Still falling
                next_state = FALL;
            end
        end
        // If digging currently
        else if (state == DIG) begin
            if (ground == 0) begin
                // No ground, start falling
                next_state = FALL;
            end else begin
                // Continue digging
                next_state = DIG;
            end
        end
        // If walking currently (left or right)
        else if (state == WALK_LEFT || state == WALK_RIGHT) begin
            if (ground == 0) begin
                // Start falling, remember walking direction
                next_state = FALL;
            end else if (dig) begin
                // Start digging, remember walking direction
                next_state = DIG;
            end else begin
                // Check bumps to switch direction
                // Bump on left or right or both causes switch
                if ((bump_left || bump_right)) begin
                    if (state == WALK_LEFT)
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end else begin
                    next_state = state;
                end
            end
        end else begin
            // Default safe case: walk left
            next_state = WALK_LEFT;
        end
    end

    // Sequential logic with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_dir <= WALK_LEFT;
        end else begin
            // Update last_walk_dir when walking or digging
            // We only update last_walk_dir if next_state is walking or digging
            if (next_state == WALK_LEFT || next_state == WALK_RIGHT || next_state == DIG) begin
                // If next_state is DIG, keep last_walk_dir unchanged because digging direction is same as last_walk_dir
                // But actually digging uses direction from last_walk_dir, so update last_walk_dir only if walking
                if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
                    last_walk_dir <= next_state;
                // If DIG, keep last_walk_dir unchanged
            end
            state <= next_state;
        end
    end

    // Moore outputs
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL: begin
                aaah = 1'b1;
            end
            DIG: begin
                digging = 1'b1;
                // Output walking direction while digging also? Problem states walk_left or walk_right only active in walking state.
                // So no walk_left/walk_right outputs when digging.
            end
        endcase
    end

endmodule