module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states of the state machine
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} current_state, next_state;

// Initialize the state machine
initial current_state = WALK_LEFT;

// State machine logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the state machine to walking left
        current_state <= WALK_LEFT;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// State machine combinational logic
always_comb begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = current_state;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = current_state;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase

    if (bump_left && bump_right) begin
        if (current_state == WALK_LEFT) begin
            next_state = WALK_RIGHT;
        end else begin
            next_state = WALK_LEFT;
        end
    end
end

// Output logic
assign walk_left = (current_state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == WALK_RIGHT) ? 1'b1 : 1'b0;

endmodule