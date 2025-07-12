module TopModule(output reg one);
  localparam logic ONE_CONST = 1'b1;

  always @(*) begin
    one = ONE_CONST;
  end
endmodule