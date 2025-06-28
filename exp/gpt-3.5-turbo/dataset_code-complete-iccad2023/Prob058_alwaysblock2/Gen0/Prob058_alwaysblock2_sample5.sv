module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

  // Assign statement method
  assign out_assign = a ^ b;

  // Combinational always block method
  always @* begin
    out_always_comb = a ^ b;
  end

  // Clocked always block method
  always @(posedge clk) begin
    out_always_ff <= a ^ b;
  end

endmodule