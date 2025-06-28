module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

// State machine process
always @(posedge clk) begin
  case(state)
    0: begin
      q <= 0;
      if (a & !b)
        next_state <= 1;
      else
        next_state <= 0;
    end
    1: begin
      q <= 1;
      if (!a & b)
        next_state <= 0;
      else
        next_state <= 1;
    end
  endcase
end

// State transition
always @(*) begin
  state <= next_state;
end

endmodule