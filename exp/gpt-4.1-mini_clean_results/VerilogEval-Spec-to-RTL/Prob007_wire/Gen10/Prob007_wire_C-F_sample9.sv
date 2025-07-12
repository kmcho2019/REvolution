module BufGate(input wire in, output wire out);
  buf b1 (out, in);
endmodule

module TopModule(input wire in, output wire out);
  BufGate buf_inst (.in(in), .out(out));
endmodule