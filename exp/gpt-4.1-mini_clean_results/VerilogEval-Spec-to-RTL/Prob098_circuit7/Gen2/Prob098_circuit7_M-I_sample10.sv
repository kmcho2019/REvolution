module TopModule(input clk, input a, output reg q);
  always @(posedge clk) begin
    if (q != ~a)  // Only update q if the new value differs
      q <= ~a;
  end
endmodule