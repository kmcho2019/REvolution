module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Use a single reg to store the current state
reg state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;  // Default state is LEFT (0)
    end else if (bump_left || bump_right) begin
        state <= ~state;  // Switch direction on bump
    end
end

// Define combinational logic using assign statements
assign walk_left = ~state;
assign walk_right = state;

endmodule