module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // 1. Assign statement - continuous combinational XOR
  assign out_assign = a ^ b;

  // 2. Combinational always block - XOR operation
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // 3. Clocked always block - register the XOR output
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule