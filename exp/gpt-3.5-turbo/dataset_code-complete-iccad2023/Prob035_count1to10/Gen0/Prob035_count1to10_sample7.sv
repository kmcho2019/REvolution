module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0001; // Reset the count to 1
    end else begin
      if (q < 4'b1010) begin
        q <= q + 1; // Increment the count if less than 10
      end
    end
  end
endmodule