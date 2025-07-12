module TopModule(output reg one, input clk, input rst_n);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      one <= 1'b1;
    else
      one <= one;
  end
endmodule