module TopModule (
  input clk,
  input a,
  input b,
  output reg [1:0] q,
  output reg [1:0] state
);

reg [1:0] q_reg;
reg [1:0] state_reg;

always @(posedge clk) begin
  // Convert binary input to Gray code
  q_reg <= {a ^ b, a};
  state_reg <= {q_reg[1] ^ q_reg[0], q_reg[1]};
end

// Sequential logic using D flip-flop for Gray code counter
always @(posedge clk) begin
  q <= q_reg;
  state <= state_reg;
end

endmodule