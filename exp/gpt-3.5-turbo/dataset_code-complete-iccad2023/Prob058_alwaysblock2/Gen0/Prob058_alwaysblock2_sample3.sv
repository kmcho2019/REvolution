module TopModule (
  input clk,
  input a,
  input b,
  output out_assign,
  output reg out_always_comb,
  output reg out_always_ff
);

// With assign statement
assign out_assign = a ^ b;

// With combinational always block
always @(*) begin
  out_always_comb = a ^ b;
end

// With clocked always block
always @(posedge clk) begin
  out_always_ff <= a ^ b;
end

endmodule