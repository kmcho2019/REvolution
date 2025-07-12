module TopModule(input wire x, input wire y, output wire z);
  wire a_out = (x ^ y) & x;
  wire b_out = ~(x ^ y);
  wire or_out = a_out | b_out;
  wire and_out = a_out & b_out;
  assign z = or_out ^ and_out;
endmodule