module TopModule(output reg zero);
  initial zero = 1'b0;
  always @(*) begin
    zero = 1'b0;
  end
endmodule