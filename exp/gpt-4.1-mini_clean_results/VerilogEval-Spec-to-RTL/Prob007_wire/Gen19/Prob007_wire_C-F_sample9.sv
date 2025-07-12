module BufPrimitive (
  input wire in,
  output wire out
);
  // Explicit buffer primitive for direct hardware mapping and timing control
  buf buf_inst (out, in);
endmodule

module TopModule #(parameter USE_BUF = 0) (
  input wire in,
  output wire out
);
  generate
    if (USE_BUF) begin
      BufPrimitive buf_inst (.in(in), .out(out));
    end else begin
      assign out = in;
    end
  endgenerate
endmodule