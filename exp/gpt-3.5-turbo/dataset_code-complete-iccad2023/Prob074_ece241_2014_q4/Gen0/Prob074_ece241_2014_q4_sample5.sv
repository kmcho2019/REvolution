module TopModule (
  input clk,
  input x,
  output reg z
);

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk) begin
  case (state)
    3'b000: next_state = x ^ 3'b000;
    3'b001: next_state = x & ~3'b001;
    3'b010: next_state = x | ~3'b010;
    default: next_state = 3'b000;
  endcase
  state <= next_state;
end

assign z = ~(state[0] | state[1] | state[2]);

endmodule