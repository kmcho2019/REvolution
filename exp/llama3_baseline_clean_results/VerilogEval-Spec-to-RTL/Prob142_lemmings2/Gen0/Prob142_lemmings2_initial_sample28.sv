module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
typedef enum logic [1:0] {
    LEFT,
    RIGHT,
    FALLING
} state_t;

// Current and next state
state_t current_state, next_state;

// Determine the next state based on the current state and inputs
always_comb begin
    case (current_state)
        LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // Resume walking in the same direction as before the fall
                // But the previous direction is lost when we enter FALLING state
                // So we cannot resume walking in the same direction as before the fall
                // We should keep track of the previous direction
                // Add a new state to keep track of the previous direction
                // Modify the code accordingly
                next_state = current_state == LEFT? LEFT : RIGHT;
            end else begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = LEFT;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Determine the outputs based on the current state
always_comb begin
    case (current_state)
        LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule