module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states of the state machine
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

// Assign the outputs based on the current state
always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

// Update the state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        // Update the state based on the inputs
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    state <= WALK_RIGHT;
                end else begin
                    state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    state <= WALK_LEFT;
                end else begin
                    state <= WALK_RIGHT;
                end
            end
        endcase
    end
end

endmodule