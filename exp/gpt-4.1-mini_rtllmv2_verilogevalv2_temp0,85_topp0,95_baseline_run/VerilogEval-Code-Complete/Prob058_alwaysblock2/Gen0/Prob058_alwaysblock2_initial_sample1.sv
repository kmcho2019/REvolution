module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // 1. assign statement XOR
  assign out_assign = a ^ b;

  // 2. combinational always block XOR
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // 3. clocked always block XOR (registered output)
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule