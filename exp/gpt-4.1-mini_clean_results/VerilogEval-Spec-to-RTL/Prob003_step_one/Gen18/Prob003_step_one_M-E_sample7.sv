module TopModule(output reg one);
  localparam logic CONST_ONE = 1'b1;
  always @(*) begin
    one = CONST_ONE;
  end
endmodule