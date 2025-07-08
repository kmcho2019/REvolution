module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

reg state_reg;

wire next_state;

assign next_state = (state_reg == 1'b0) ? 
                      ((b && !a) ? 1'b1 : 
                       ((a && b) ? 1'b0 : 1'b0))
                   : // state_reg == 1
                      ((a && !b) ? 1'b0 : 1'b1);

always @(posedge clk) begin
  state_reg <= next_state;
end

always @(*) begin
  q = state_reg;
end

assign state = state_reg;

endmodule