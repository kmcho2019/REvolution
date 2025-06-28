module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;

always @ (posedge clk) begin
  if (a == 1'b1) begin
    if (q < 3'd6) // Increment counter if 'a' is high
      q <= q + 1;
  end else begin
    if (a_prev == 1'b1) // Check if 'a' was high in the previous cycle
      q <= 3'b0; // Reset counter to 0 if 'a' was high in the previous cycle
  end
  a_prev <= a; // Store the value of 'a' for the next cycle
end

endmodule