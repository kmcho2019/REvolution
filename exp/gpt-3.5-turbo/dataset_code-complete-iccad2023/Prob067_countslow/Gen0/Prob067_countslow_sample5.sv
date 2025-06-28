module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

// Synchronous decade counter
always @(posedge clk) begin
  if (reset) begin
    q <= 4'b0; // Reset to 0
  end else begin
    if (slowena) begin
      if (q == 4'b1001) // Check if q is 9 (1001 in binary)
        q <= 4'b0; // Reset to 0
      else
        q <= q + 4'b1; // Increment by 1
    end
  end
end

endmodule