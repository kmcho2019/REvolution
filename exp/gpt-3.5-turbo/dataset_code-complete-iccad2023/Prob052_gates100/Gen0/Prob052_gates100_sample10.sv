module TopModule (
  input [99:0] in,
  output out_and,
  output out_or,
  output out_xor
);

wire [99:0] and_intermediate;
wire [99:0] or_intermediate;
wire [99:0] xor_intermediate;

assign out_and = &and_intermediate;
assign out_or = |or_intermediate;
assign out_xor = ^xor_intermediate;

AND_gate_100bit and_gate_instance (
  .in(in),
  .out(and_intermediate)
);

OR_gate_100bit or_gate_instance (
  .in(in),
  .out(or_intermediate)
);

XOR_gate_100bit xor_gate_instance (
  .in(in),
  .out(xor_intermediate)
);

endmodule

module AND_gate_100bit (
  input [99:0] in,
  output [99:0] out
);

assign out = &in;

endmodule

module OR_gate_100bit (
  input [99:0] in,
  output [99:0] out
);

assign out = |in;

endmodule

module XOR_gate_100bit (
  input [99:0] in,
  output [99:0] out
);

assign out = ^in;

endmodule