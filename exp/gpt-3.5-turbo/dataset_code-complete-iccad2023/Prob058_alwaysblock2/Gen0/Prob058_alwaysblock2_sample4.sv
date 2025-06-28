module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

// XOR using assign statement
assign out_assign = a ^ b;

// XOR using combinational always block
always @(*) begin
  out_always_comb = a ^ b;
end

// XOR using clocked always block with flip-flop
reg xor_result_ff;
always @(posedge clk) begin
  xor_result_ff <= a ^ b;
end
always @(posedge clk) begin
  out_always_ff <= xor_result_ff;
end

endmodule