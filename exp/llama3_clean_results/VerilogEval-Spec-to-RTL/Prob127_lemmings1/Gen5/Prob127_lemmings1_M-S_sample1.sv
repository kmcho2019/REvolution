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
    end
end

// Define combinational logic
always_comb begin
    next_state = (bump_left || bump_right) ? (state == LEFT ? RIGHT : LEFT) : state;
    walk_left = (state == LEFT) ? 1'b1 : 1'b0;
    walk_right = (state == RIGHT) ? 1'b1 : 1'b0;
end

endmodule