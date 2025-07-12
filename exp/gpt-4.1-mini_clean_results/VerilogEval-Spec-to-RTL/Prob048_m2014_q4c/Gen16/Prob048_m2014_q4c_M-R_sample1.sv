module TopModule(input clk, input d, input r, output reg q);
  reg d_sync;

  always @(*) begin
    if (r)
      d_sync = 1'b0;
    else
      d_sync = d;
  end

  always @(posedge clk) begin
    q <= d_sync;
  end
endmodule