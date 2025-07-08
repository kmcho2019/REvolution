module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // 1. Combinational XOR using assign statement
  assign out_assign = a ^ b;

  // 2. Combinational XOR using always block (combinational)
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // 3. Sequential XOR using always block with clock (flip-flop)
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule