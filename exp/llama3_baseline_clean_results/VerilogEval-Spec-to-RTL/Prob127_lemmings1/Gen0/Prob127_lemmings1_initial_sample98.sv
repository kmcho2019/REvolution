module TopModule (
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    output       walk_left,
    output       walk_right
);

// Enum to represent the states of the state machine
enum logic [0:0] { walk_left_state, walk_right_state } current_state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (current_state)
        walk_left_state: begin
            if (bump_left) begin
                next_state = walk_right_state;
            end else begin
                next_state = walk_left_state;
            end
        end
        walk_right_state: begin
            if (bump_right) begin
                next_state = walk_left_state;
            end else begin
                next_state = walk_right_state;
            end
        end
        default: begin
            next_state = walk_left_state;
        end
    endcase

    // Override next state if both bump_left and bump_right are asserted
    if (bump_left && bump_right) begin
        case (current_state)
            walk_left_state: begin
                next_state = walk_right_state;
            end
            walk_right_state: begin
                next_state = walk_left_state;
            end
            default: begin
                next_state = walk_left_state;
            end
        endcase
    end
end

// Sequential logic to update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walk_left_state;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always_comb begin
    case (current_state)
        walk_left_state: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        walk_right_state: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule