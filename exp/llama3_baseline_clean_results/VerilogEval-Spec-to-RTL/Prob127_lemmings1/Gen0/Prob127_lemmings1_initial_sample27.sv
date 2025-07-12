module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Next state logic
always_comb begin
    case (state)
        LEFT: next_state = (bump_left) ? RIGHT : (bump_right) ? LEFT : LEFT;
        RIGHT: next_state = (bump_left) ? LEFT : (bump_right) ? LEFT : RIGHT;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= (bump_left && bump_right) ? (state == LEFT) ? RIGHT : LEFT : next_state;
    end
end

// Output logic
always_comb begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule