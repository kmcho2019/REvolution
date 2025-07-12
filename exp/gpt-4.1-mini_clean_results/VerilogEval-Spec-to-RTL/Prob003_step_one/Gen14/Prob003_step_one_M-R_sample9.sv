module TopModule(output reg one);
  // Use always block with combinational sensitivity to assign constant 1
  always @(*) begin
    one = 1'b1;
  end
endmodule