module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;

always @ (posedge clk) begin
  a_prev <= a; // Store the previous value of 'a' for comparison

  if (a == 1 && a_prev == 1) begin // Check if 'a' is high for consecutive clock cycles
    if (q == 6) // Reset counter to 0 when it reaches 6
      q <= 0;
    else
      q <= q + 1; // Increment counter
  end else if (a == 0) begin
    q <= q; // Maintain current count when 'a' is low
  end
end

endmodule