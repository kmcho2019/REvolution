module TopModule (
  input clk,
  input x,
  output z
);
  reg q_xor, q_and, q_or;

  // Next state logic
  wire d_xor = x ^ q_xor;
  wire d_and = x & (~q_and);
  wire d_or  = x | (~q_or);

  // Flip-flops with synchronous reset to zero at start (assumed)
  // Since no reset input is given, we initialize registers to zero
  initial begin
    q_xor = 1'b0;
    q_and = 1'b0;
    q_or  = 1'b0;
  end

  always @(posedge clk) begin
    q_xor <= d_xor;
    q_and <= d_and;
    q_or  <= d_or;
  end

  // Output z is NOR of the three flip-flop outputs
  assign z = ~(q_xor | q_and | q_or);

endmodule