module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  next_state <= state;
  case ({a, b, state})
    3'b001: next_state <= 1;  // Transition from state 0 to state 1 when a = 0 and b = 1
    3'b110: next_state <= 0;  // Transition from state 1 to state 0 when a = 1 and b = 0
    3'b111: next_state <= 0;  // Transition from state 1 to state 0 when a = 1 and b = 1
    3'b101: next_state <= 1;  // Transition from state 1 to state 1 when a = 0 and b = 1
  endcase
end

always @(posedge clk) begin
  state <= next_state;
end

always @(*) begin
  case (state)
    0: q = 0;
    1: q = 1;
  endcase
end

endmodule