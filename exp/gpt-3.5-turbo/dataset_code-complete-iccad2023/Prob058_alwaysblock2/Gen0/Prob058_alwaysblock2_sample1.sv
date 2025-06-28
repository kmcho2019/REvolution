module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // Method 1: Using assign statement
  assign out_assign = a ^ b;
  
  // Method 2: Using combinational always block
  always @(*) begin
    out_always_comb = a ^ b;
  end

  // Method 3: Using clocked always block with flip-flop
  reg out_ff;
  always @(posedge clk) begin
    out_ff <= a ^ b;
  end
  always @(posedge clk) begin
    out_always_ff <= out_ff;
  end

endmodule