module TopModule(input a, input b, output reg out);
  always @(a or b) begin
    if (a == 1'b1 && b == 1'b1) begin
      out = 1'b1;
    end else begin
      out = 1'b0;
    end
  end
endmodule