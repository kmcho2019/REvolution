module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

  initial q = 3'd4;

  always @(posedge clk) begin
    if (a == 1'b1) begin
      q <= 3'd4;
    end else begin
      if (q == 3'd6)
        q <= 3'd0;
      else
        q <= q + 3'd1;
    end
  end

endmodule