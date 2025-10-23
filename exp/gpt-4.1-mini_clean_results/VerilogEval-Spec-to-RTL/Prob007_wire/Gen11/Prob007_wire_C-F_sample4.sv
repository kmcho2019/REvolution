module BufPrimitive #(parameter WIDTH = 1) (input wire [WIDTH-1:0] in, output wire [WIDTH-1:0] out);
  // For each bit, instantiate a buf primitive for guaranteed minimal hardware mapping
  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : buf_loop
      buf b_inst (out[i], in[i]);
    end
  endgenerate
endmodule

module TopModule(input wire in, output wire out);
  BufPrimitive #(.WIDTH(1)) buf_inst (.in(in), .out(out));
endmodule