module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // Method 1: Continuous assignment
  assign out_assign = a ^ b;

  // Method 2: Combinational always block
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // Method 3: Clocked always block (flip-flop)
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule