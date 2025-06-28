module TopModule (
  input clk,
  input a,
  input b,
  output [1:0] state,
  output [1:0] q
);

reg [1:0] q_reg;
reg [1:0] state_reg;

always @(posedge clk) begin
  q_reg <= {a ^ b, a};
  state_reg <= {q_reg[1] ^ q_reg[0], q_reg[1]};
end

assign q = q_reg;
assign state = state_reg;

endmodule