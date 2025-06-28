module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (q == 3'd7) // Reset the counter when it reaches 7
    q <= 3'b0;
  else
    q <= q + 1; // Increment the counter for each clock cycle
end

endmodule