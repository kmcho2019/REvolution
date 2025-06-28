module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev; // Previous value of 'a'

always @ (posedge clk) begin
  if (a == 1'b1 && a_prev == 1'b0) begin
    if (q < 3'd6) // Counter should increment from 0 to 6
      q <= q + 1;
  end else if (a == 1'b0 && a_prev == 1'b0) begin
    q <= 3'b0; // Reset counter to 0 only when 'a' remains 0 for multiple clock cycles
  end
  a_prev <= a; // Store current 'a' value for next iteration
end

endmodule