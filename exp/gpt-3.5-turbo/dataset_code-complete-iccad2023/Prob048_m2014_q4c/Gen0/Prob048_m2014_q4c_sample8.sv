module d_ff_with_sync_reset (
  input clk, // clock input
  input d,   // data input
  input r,   // active high synchronous reset
  output reg q // output
);

  always @(posedge clk) begin
    if (r) begin
      q <= 1'b0;
    end else begin
      q <= d;
    end
  end

endmodule