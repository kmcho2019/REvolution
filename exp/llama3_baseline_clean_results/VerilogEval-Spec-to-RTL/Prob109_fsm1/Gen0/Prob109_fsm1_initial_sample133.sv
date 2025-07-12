module TopModule (
  input clk,
  input areset,
  input in,
  output reg out
);

reg state;  // 1-bit register to hold the current state

always @(posedge clk or posedge areset) begin
  if (areset) begin  // asynchronous reset
    state <= 1;  // reset to state B
  end else begin
    case (state)
      1'b1: begin  // current state is B
        if (~in) begin
          state <= 1'b0;  // next state is A
        end else begin
          state <= 1'b1;  // next state remains B
        end
      end
      1'b0: begin  // current state is A
        if (~in) begin
          state <= 1'b1;  // next state is B
        end else begin
          state <= 1'b0;  // next state remains A
        end
      end
    endcase
  end
end

always @(*) begin
  case (state)
    1'b1: out = 1;  // output is 1 when state is B
    1'b0: out = 0;  // output is 0 when state is A
  endcase
end

endmodule