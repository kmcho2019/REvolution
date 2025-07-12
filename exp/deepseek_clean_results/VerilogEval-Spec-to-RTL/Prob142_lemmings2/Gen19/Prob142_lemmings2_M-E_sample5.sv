module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // Main states
    typedef enum {WALKING, FALLING} state_t;
    state_t state, next_state;

    // Direction substates (only valid in WALKING state)
    reg direction;  // 0=left, 1=right

    // Edge detection for ground signal
    reg ground_prev;
    wire ground_falling_edge = ground_prev && !ground;
    wire ground_rising_edge = !ground_prev && ground;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 0;
            ground_prev <= 1;
        end else begin
            ground_prev <= ground;
            
            case (state)
                WALKING: begin
                    if (ground_falling_edge)
                        state <= FALLING;
                end
                FALLING: begin
                    if (ground_rising_edge)
                        state <= WALKING;
                end
            endcase

            // Direction change logic (only when walking)
            if (state == WALKING) begin
                if (bump_left && !direction)
                    direction <= 1;
                else if (bump_right && direction)
                    direction <= 0;
            end
        end
    end

    // Output logic (registered)
    always @(posedge clk) begin
        aaah <= (state == FALLING);
        walk_left <= (state == WALKING) && !direction;
        walk_right <= (state == WALKING) && direction;
    end

endmodule