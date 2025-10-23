module BufPrimitive #(parameter WIDTH = 1) (
  input wire [WIDTH-1:0] in,
  output wire [WIDTH-1:0] out
);
  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : buf_loop
      buf b_inst (out[i], in[i]);
    end
  endgenerate
endmodule

module TopModule #(parameter USE_BUF = 0) (
  input wire in,
  output wire out
);
  generate
    if (USE_BUF) begin
      BufPrimitive #(.WIDTH(1)) buf_inst (.in(in), .out(out));
    end else begin
      assign out = in;
    end
  endgenerate
endmodule