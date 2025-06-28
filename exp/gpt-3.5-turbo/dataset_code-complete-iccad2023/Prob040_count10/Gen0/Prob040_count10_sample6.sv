module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0000; // reset to 0
    end
    else begin
      if (q == 4'b1001) // if count is 9
        q <= 4'b0000;  // reset to 0
      else
        q <= q + 1;    // increment the count
    end
  end

endmodule