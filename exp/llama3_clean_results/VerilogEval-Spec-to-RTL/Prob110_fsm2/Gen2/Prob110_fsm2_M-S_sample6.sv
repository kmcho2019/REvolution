module TopModule(
  input  clk,
  input  areset,
  input  j,
  input  k,
  output reg out
);

reg state;

// Output logic
assign out = state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1'b0;
  end else begin
    case(state)
      1'b0: state <= j ? 1'b1 : 1'b0;
      1'b1: state <= k ? 1'b0 : 1'b1;
    endcase
  end
end

endmodule