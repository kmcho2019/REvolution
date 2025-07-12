module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        state <= next_state;
        case (next_state)
            LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
        endcase
    end
end

// Define combinational logic for next state
always_comb begin
    next_state = state;
    if (bump_left && state == LEFT) begin
        next_state = RIGHT;
    end else if (bump_right && state == RIGHT) begin
        next_state = LEFT;
    end
end

endmodule