module TopModule(input wire in, output wire out);
  wire internal_wire;
  assign internal_wire = in;
  assign out = internal_wire;
endmodule