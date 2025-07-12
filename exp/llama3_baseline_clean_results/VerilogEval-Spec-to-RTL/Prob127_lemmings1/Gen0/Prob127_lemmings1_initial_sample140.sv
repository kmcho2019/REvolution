module TopModule (
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    output        walk_left,
    output        walk_right
);

// Define the states
typedef enum logic [0:0] {
    LEFT,
    RIGHT
} state_t;

// Declare the current state and the next state
state_t current_state, next_state;

// Assign the outputs based on the current state
always_comb begin
    case (current_state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

// Handle the state transitions
always_comb begin
    case (current_state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
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
        if (bump_left && bump_right) begin
            if (current_state == LEFT) begin
                current_state <= RIGHT;
            end else begin
                current_state <= LEFT;
            end
        end else begin
            current_state <= next_state;
        end
    end
end

endmodule