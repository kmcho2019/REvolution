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
      assign out = in;
    end
  endgenerate
endmodule