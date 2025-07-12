module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire [1:0] a_out;
  wire [1:0] b_out;
  wire or_result, and_result;

  genvar i;
  generate
    for (i = 0; i < 2; i = i + 1) begin : gen_pairs
      A a_inst(.x(x), .y(y), .z(a_out[i]));
      B b_inst(.x(x), .y(y), .z(b_out[i]));
    end
  endgenerate

  assign or_result = a_out[0] | b_out[0];
  assign and_result = a_out[1] & b_out[1];
  assign z = or_result ^ and_result;
endmodule