module TopModule(
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
enum logic [1:0] {LEFT, RIGHT, FALL} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    // Default values
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;

    // Determine the next state
    case (state)
        LEFT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (bump_left) begin
                next_state = RIGHT;
            end
        end
        RIGHT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (bump_right) begin
                next_state = LEFT;
            end
        end
        FALL: begin
            if (ground) begin
                // Return to the previous walking state
                if (bump_left && bump_right) begin
                    // If both bump_left and bump_right are high, switch direction
                    if (state == LEFT) begin
                        next_state = RIGHT;
                    end else if (state == RIGHT) begin
                        next_state = LEFT;
                    end
                end else if (bump_left) begin
                    next_state = RIGHT;
                end else if (bump_right) begin
                    next_state = LEFT;
                end else begin
                    // If neither bump_left nor bump_right is high, return to the previous state
                    next_state = state;
                end
            end
        end
    endcase

    // Determine the output
    case (state)
        LEFT: begin
            walk_left = 1;
        end
        RIGHT: begin
            walk_right = 1;
        end
        FALL: begin
            aaah = 1;
        end
    endcase
end

endmodule