module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// Define an enumeration for the states
typedef enum {LEFT, RIGHT} state_t;

reg [0:0] state; // Using a 1-bit state variable

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 0; // Initialize state to LEFT (0)
  end else begin
    case (state)
      0: state <= (bump_left)? 1 : 0; // LEFT state
      1: state <= (bump_right)? 0 : 1; // RIGHT state
      default: state <= 0; // Default to LEFT state
    endcase
  end
end

// Use assign statements for combinational logic
assign walk_left = (state == 0); // LEFT state
assign walk_right = (state == 1); // RIGHT state

endmodule