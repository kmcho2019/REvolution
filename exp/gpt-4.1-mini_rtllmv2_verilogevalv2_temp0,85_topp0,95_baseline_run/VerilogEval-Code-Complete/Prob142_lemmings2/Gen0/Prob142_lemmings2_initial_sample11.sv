module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Sequential state register with asynchronous positive-edge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Combinational next-state logic
    always_comb begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction if bumped on either side
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction if bumped on either side
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Return to walking in the last direction before falling
                    // To know the last direction, we must store it.
                    // Because state only holds FALLING, we need a separate reg to remember direction.

                    // Will implement direction memory below.
                    // For now, next_state assigned in separate logic.
                    // Placeholder here:
                    next_state = FALLING; // will override below
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Direction memory: We need to remember last walking direction during FALLING state
    // We'll store it in a reg "last_dir" which is 0 for left, 1 for right.
    // Update it when entering WALK_LEFT or WALK_RIGHT states.
    logic last_dir; // 0 = left, 1 = right

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            last_dir <= 1'b0; // start walking left
        end else begin
            if (state == WALK_LEFT)
                last_dir <= 1'b0;
            else if (state == WALK_RIGHT)
                last_dir <= 1'b1;
            // do not update last_dir in FALLING
        end
    end

    // Now update FALLING state's next_state properly depending on last_dir and ground
    always_comb begin
        if (state == FALLING) begin
            if (ground) begin
                next_state = last_dir ? WALK_RIGHT : WALK_LEFT;
            end else begin
                next_state = FALLING;
            end
        end
    end

    // Output logic (Moore): 
    // walk_left and walk_right mutually exclusive, aaah asserted only during FALLING
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule