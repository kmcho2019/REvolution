module TopModule(input wire in, output wire out);
  reg tmp;
  always @(*) begin
    tmp = in; // latch behavior, transparent combinational assignment
  end
  assign out = tmp;
endmodule