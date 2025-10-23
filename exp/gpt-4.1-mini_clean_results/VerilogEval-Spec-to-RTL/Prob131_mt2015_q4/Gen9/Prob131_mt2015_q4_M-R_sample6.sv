module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = 1 if x equals y, else 0 (equality operator used)
  assign z = (x == y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire [1:0] a_out;
  wire [1:0] b_out;
  wire or_out, and_out;

  genvar i;
  generate
    for (i = 0; i < 2; i = i + 1) begin : gen_submodules
      A a_inst(.x(x), .y(y), .z(a_out[i]));
      B b_inst(.x(x), .y(y), .z(b_out[i]));
    end
  endgenerate

  assign or_out = a_out[0] | b_out[0];
  assign and_out = a_out[1] & b_out[1];
  assign z = or_out ^ and_out;
endmodule