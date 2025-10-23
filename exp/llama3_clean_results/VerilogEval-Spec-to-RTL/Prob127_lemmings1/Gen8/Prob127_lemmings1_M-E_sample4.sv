module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// Define one-hot encoded states
reg [1:0] state;

// Sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 2'b01; // Initialize to walking left
  end else begin
    case (state)
      2'b01: state <= (bump_left) ? 2'b10 : 2'b01; // Walking left, bump left -> walking right
      2'b10: state <= (bump_right) ? 2'b01 : 2'b10; // Walking right, bump right -> walking left
      default: state <= 2'b01; // Default to walking left
    endcase
  end
end

// Combinational logic
always @(*) begin
  case (state)
    2'b01: begin
      walk_left = 1'b1;
      walk_right = 1'b0;
    end
    2'b10: begin
      walk_left = 1'b0;
      walk_right = 1'b1;
    end
    default: begin
      walk_left = 1'b1;
      walk_right = 1'b0;
    end
  endcase
end

endmodule