module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  if (state == 0 && a == 0 && b == 1) begin
    next_state = 1;
    q = 1;
  end else if (state == 1 && a == 1 && b == 0) begin
    next_state = 0;
    q = 1;
  end else if (state == 1 && a == 1 && b == 1) begin
    next_state = 0;
    q = 0;
  end else if (state == 1 && a == 0 && b == 1) begin
    next_state = 1;
    q = 0;
  end else begin
    next_state = state;
    q = state;
  end
end

always @(posedge clk) begin
  state <= next_state;
end

endmodule