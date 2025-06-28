module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

// Assign statement approach
assign out_assign = a ^ b;

// Combinational always block approach
always @(*) begin
  out_always_comb <= a ^ b;
end

// Clocked always block approach
reg xor_result_ff;
always @(posedge clk) begin
  xor_result_ff <= a ^ b;
  out_always_ff <= xor_result_ff;
end

endmodule