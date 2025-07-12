module TopModule(
  input  clk,
  input  areset,
  input  j,
  input  k,
  output reg out
);

// Define states as binary values
reg [0:0] state, next_state;

// Output logic
assign out = state;

// Next state logic
always_comb begin
  case(state)
    1'b0: next_state = j ? 1'b1 : 1'b0;
    1'b1: next_state = k ? 1'b0 : 1'b1;
  endcase
end

// Sequential logic with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1'b0;
  end else begin
    state <= next_state;
  end
end

endmodule