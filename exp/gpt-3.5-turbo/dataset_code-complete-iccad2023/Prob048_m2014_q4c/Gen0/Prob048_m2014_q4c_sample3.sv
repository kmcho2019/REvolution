module dff_with_reset (
  input clk,
  input d,
  input r,
  output reg q
);

  always @(posedge clk) begin
    if (r) begin
      q <= 1'b0; // active high reset
    end else begin
      q <= d;
    end
  end

endmodule