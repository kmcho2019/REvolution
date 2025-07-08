module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // 1. assign statement for XOR
  assign out_assign = a ^ b;

  // 2. combinational always block for XOR
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // 3. clocked always block for XOR with flip-flop delay
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule