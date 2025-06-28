module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  case({a, b})
    2'b00: next_state <= state;
    default: next_state <= ~state;
  endcase

  state <= next_state;
  q <= (state == 1) ? 1 : 0;
end

endmodule