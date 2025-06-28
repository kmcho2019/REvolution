module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

// Using assign statement for out_assign
assign out_assign = a ^ b;

// Using combinational always block for out_always_comb
always @(*) begin
  out_always_comb = a ^ b;
end

// Using clocked always block for out_always_ff
always @(posedge clk) begin
  out_always_ff <= a ^ b;
end

endmodule