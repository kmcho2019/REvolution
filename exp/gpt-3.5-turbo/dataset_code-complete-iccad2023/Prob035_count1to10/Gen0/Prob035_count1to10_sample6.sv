module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0001; // reset to 1 when reset is active
    end
    else if (q < 4'b1010) begin
      q <= q + 4'b0001; // increment count if not at 10
    end
    else begin
      q <= 4'b0001; // reset to 1 when count reaches 10
    end
  end

endmodule