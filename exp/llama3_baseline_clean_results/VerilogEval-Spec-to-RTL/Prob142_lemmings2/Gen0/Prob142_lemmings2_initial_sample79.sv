module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
enum logic [1:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING
} state, next_state;

// Output logic
assign walk_left = (state == IDLE_LEFT);
assign walk_right = (state == IDLE_RIGHT);
assign aaah = (state == FALLING);

// State machine logic
always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (~ground) begin
                next_state = FALLING;
            end
        end
        IDLE_RIGHT: begin
            if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (~ground) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            if (ground) begin
                // Resume walking in the same direction as before the fall
                // We can't know the exact direction from the falling state,
                // but we can use the current state to determine the direction
                // before the fall. Since we can't change the state during
                // falling, we need to save the previous state before falling.
                // We can do this by adding an additional state or by using
                // a separate register to save the previous state.
                // For simplicity, we will use a separate register to save
                // the previous state.
                if (previous_state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (previous_state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
    endcase
end

// Save the previous state before falling
logic [1:0] previous_state;
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        previous_state <= IDLE_LEFT;
    end else begin
        if (~ground && (state == IDLE_LEFT || state == IDLE_RIGHT)) begin
            previous_state <= state;
        end
        state <= next_state;
    end
end

endmodule