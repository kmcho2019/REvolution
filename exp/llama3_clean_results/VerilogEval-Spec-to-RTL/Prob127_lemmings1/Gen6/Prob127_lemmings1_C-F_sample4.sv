module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// Define an enumeration for the states to improve readability
typedef enum {LEFT, RIGHT} state_t;

// Use a single reg variable to store the current state for efficiency
reg state;

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1'b0; // Initialize state to LEFT (0)
  end else begin
    // Simplify the sequential logic for better performance
    if (bump_left && !bump_right) begin
      state <= 1'b1; // Switch to RIGHT (1) if bumped on the left
    end else if (bump_right && !bump_left) begin
      state <= 1'b0; // Switch to LEFT (0) if bumped on the right
    end else if (bump_left && bump_right) begin
      state <= ~state; // Switch direction if bumped on both sides
    end
  end
end

// Use assign statements for combinational logic to minimize area and power
assign walk_left = ~state;
assign walk_right = state;

endmodule