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
    end else begin
        state <= next_state;
    end
end

// Define combinational logic
always_comb begin
    next_state = state;
    walk_left = (state == LEFT);
    walk_right = (state == RIGHT);
    
    if (state == LEFT && (bump_left || bump_right)) begin
        next_state = RIGHT;
    end else if (state == RIGHT && (bump_left || bump_right)) begin
        next_state = LEFT;
    end
end

endmodule