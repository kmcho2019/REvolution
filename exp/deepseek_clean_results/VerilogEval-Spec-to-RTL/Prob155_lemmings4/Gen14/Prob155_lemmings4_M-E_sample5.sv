module TopModule (
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

    // Primary states
    typedef enum logic [1:0] {
        WALK,
        FALL,
        DIG,
        SPLAT
    } state_t;

    // Direction states
    typedef enum logic {
        LEFT,
        RIGHT
    } dir_t;

    // State registers
    state_t state, next_state;
    dir_t direction, next_direction;
    logic [4:0] fall_counter;

    // Priority evaluation
    always_comb begin
        // Default next state values
        next_state = state;
        next_direction = direction;

        // Evaluate highest priority action
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    // Handle direction changes
                    if (bump_left) next_direction = RIGHT;
                    if (bump_right) next_direction = LEFT;
                end
            end

            FALL: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : WALK;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end

            SPLAT: begin
                // Stay in splattered state
                next_state = SPLAT;
            end
        endcase
    end

    // State update and fall counter
    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;

            // Update fall counter
            if (state == FALL) begin
                if (!ground) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    fall_counter <= 0;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) && (direction == LEFT);
    assign walk_right = (state == WALK) && (direction == RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule