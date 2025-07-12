module TopModule(output reg zero);
  always @(posedge clk) begin
    zero <= 1'b0;
  end

  initial begin
    zero = 1'b0;
  end
endmodule