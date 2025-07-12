module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to walking left
    end else begin
        // Toggle state when bumped from either side
        state <= state ^ (bump_left || bump_right);
    end
end

// Define combinational logic
always_comb begin
    // Directly handle outputs based on current state
    walk_left = state;
    walk_right = ~state;
end

endmodule