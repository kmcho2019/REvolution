module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states of the FSM
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Output logic
assign walk_left = (state == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == RIGHT) ? 1'b1 : 1'b0;

// State machine logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = state;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = state;
            end
        end
    endcase

    // Handle both bumps at the same time
    if (bump_left && bump_right) begin
        case (state)
            LEFT: next_state = RIGHT;
            RIGHT: next_state = LEFT;
        endcase
    end
end

endmodule