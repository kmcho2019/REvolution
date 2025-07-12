module TopModule(input in, output reg out);
  wire in_wire = in;
  always @(*) begin
    out = in_wire;
  end
endmodule