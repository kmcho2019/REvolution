module WirePassThrough #(parameter WIDTH = 1) (input wire [WIDTH-1:0] in, output wire [WIDTH-1:0] out);
  assign out = in;
endmodule

module TopModule(input wire in, output wire out);
  WirePassThrough #(.WIDTH(1)) wire_inst(.in(in), .out(out));
endmodule