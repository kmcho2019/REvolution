module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output reg z);
  // From given waveform, z=1 if (x,y)=(0,0) or (1,1), else 0
  always @(*) begin
    if ((x == 0 && y == 0) || (x == 1 && y == 1))
      z = 1;
    else
      z = 0;
  end
endmodule

module top(input x, input y, output z);
  wire a1, a2, b1, b2;
  wire or_out, and_out;

  A A1(.x(x), .y(y), .z(a1));
  B B1(.x(x), .y(y), .z(b1));
  A A2(.x(x), .y(y), .z(a2));
  B B2(.x(x), .y(y), .z(b2));

  assign or_out = a1 | b1;
  assign and_out = a2 & b2;

  assign z = or_out ^ and_out;
endmodule