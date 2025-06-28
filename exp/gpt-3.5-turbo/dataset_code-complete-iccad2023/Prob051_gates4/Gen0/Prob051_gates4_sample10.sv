module TopModule (
  input [3:0] in,
  output out_and,
  output out_or,
  output out_xor
);

  wire [3:0] and_w, or_w, xor_w;

  assign out_and = and_w[3];
  assign out_or = or_w[3];
  assign out_xor = xor_w[3];

  and #4 and_gate (
    .a(in[0]),
    .b(in[1]),
    .c(in[2]),
    .d(in[3]),
    .out(and_w)
  );

  or #4 or_gate (
    .a(in[0]),
    .b(in[1]),
    .c(in[2]),
    .d(in[3]),
    .out(or_w)
  );

  xor #4 xor_gate (
    .a(in[0]),
    .b(in[1]),
    .c(in[2]),
    .d(in[3]),
    .out(xor_w)
  );

endmodule

module and #(
  parameter WIDTH = 1
)(
  input [WIDTH-1:0] a, b, c, d,
  output reg [WIDTH-1:0] out
);
  always @* begin
    out = a & b & c & d;
  end
endmodule

module or #(
  parameter WIDTH = 1
)(
  input [WIDTH-1:0] a, b, c, d,
  output reg [WIDTH-1:0] out
);
  always @* begin
    out = a | b | c | d;
  end
endmodule

module xor #(
  parameter WIDTH = 1
)(
  input [WIDTH-1:0] a, b, c, d,
  output reg [WIDTH-1:0] out
);
  always @* begin
    out = a ^ b ^ c ^ d;
  end
endmodule