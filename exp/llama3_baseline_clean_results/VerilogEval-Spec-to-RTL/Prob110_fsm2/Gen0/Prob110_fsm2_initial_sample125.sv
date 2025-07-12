module TopModule(
  input  clk,
  input  areset,
  input  j,
  input  k,
  output reg out
);

reg state; // Current state (OFF = 0, ON = 1)

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 0; // Reset to OFF state
  end else begin
    case (state)
      0: if (j) state <= 1; // OFF to ON on j=1
           else state <= 0; // Stay in OFF on j=0
      1: if (k) state <= 0; // ON to OFF on k=1
           else state <= 1; // Stay in ON on k=0
    endcase
  end
end

always @(*) begin
  case (state)
    0: out = 0; // Output is 0 in OFF state
    1: out = 1; // Output is 1 in ON state
  endcase
end

endmodule