module WirePassThrough #(parameter WIDTH = 1) (
  input wire [WIDTH-1:0] in,
  output wire [WIDTH-1:0] out
);
  assign out = in;
endmodule

module BufGate(input wire in, output wire out);
  assign out = in;
endmodule

module TopModule #(parameter USE_BUF = 0) (
  input wire in,
  output wire out
);
  generate
    if (USE_BUF) begin
      BufGate buf_inst (.in(in), .out(out));
    end else begin
      WirePassThrough #(.WIDTH(1)) wire_pass (.in(in), .out(out));
    end
  endgenerate
endmodule