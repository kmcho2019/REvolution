module TopModule(clk, x, z);
  input clk;
  input x;
  output z;
  reg q_xor, q_and, q_or;
  wire xor_out, and_out, or_out;

  // XOR gate
  assign xor_out = x ^ q_xor;

  // AND gate
  assign and_out = x & ~q_and;

  // OR gate
  assign or_out = x | ~q_or;

  // D flip-flops
  always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
  end

  // NOR gate
  assign z = ~(xor_out | and_out | or_out);

  // Initialize flip-flops to zero
  initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
  end
endmodule