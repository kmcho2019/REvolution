module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT} current_state, next_state;

// Assign the outputs based on the current state
always_comb begin
    case (current_state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

// Define the next state logic
always_comb begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            if (current_state == WALK_LEFT) begin
                current_state <= WALK_RIGHT;
            end else begin
                current_state <= WALK_LEFT;
            end
        end else begin
            current_state <= next_state;
        end
    end
end

endmodule