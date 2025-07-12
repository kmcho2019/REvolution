module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Based on waveform, z = ~(x ^ y) (XNOR)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire clk, input wire x, input wire y, output reg z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_comb, and_comb;
  reg or_reg;

  // Instantiate two A modules
  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));

  // Instantiate two B modules
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // Combinational OR of first A and B outputs
  assign or_comb = a1_out | b1_out;

  // Register the OR result to introduce pipelining
  always @(posedge clk) begin
    or_reg <= or_comb;
  end

  // Combinational AND of second A and B outputs
  assign and_comb = a2_out & b2_out;

  // Final output is XOR of registered OR output and combinational AND output
  always @(posedge clk) begin
    z <= or_reg ^ and_comb;
  end
endmodule