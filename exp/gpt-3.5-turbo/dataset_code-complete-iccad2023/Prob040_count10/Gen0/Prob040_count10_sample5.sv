module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  // Synchronous decade counter
  always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0; // Reset to 0
    end else begin
      if (q == 4'd9) begin
        q <= 4'b0; // Reset to 0 at the end of the decade
      end else begin
        q <= q + 1; // Increment the counter
      end
    end
  end

endmodule