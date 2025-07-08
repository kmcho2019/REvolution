module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // Continuous assignment for combinational XOR
  assign out_assign = a ^ b;

  // Combinational always block for XOR
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // Clocked always block for XOR output with one clock cycle delay
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule