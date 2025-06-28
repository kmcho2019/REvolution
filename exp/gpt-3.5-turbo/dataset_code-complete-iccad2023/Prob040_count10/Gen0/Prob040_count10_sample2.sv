module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0; // Reset count to 0
    end else begin
      q <= (q == 4'b1001) ? 4'b0 : q + 1; // Increment count if not at 9
    end
  end

endmodule