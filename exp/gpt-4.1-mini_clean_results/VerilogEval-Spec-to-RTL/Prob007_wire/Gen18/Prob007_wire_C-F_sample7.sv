module WireBuffer(input wire in, output wire out);
  assign out = in;
endmodule

module TopModule(input wire in, output wire out);
  WireBuffer buf_inst (.in(in), .out(out));
endmodule