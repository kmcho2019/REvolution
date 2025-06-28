module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
  if (reset) begin
    counter <= 4'b0000; // Reset the counter to 0
    q <= counter + 1;   // Output 1 on reset
  end
  else begin
    if (counter == 4'b1001) // If counter reaches 9
      counter <= 4'b0;     // Reset counter to 0
    else
      counter <= counter + 1; // Increment counter
    q <= counter + 1;       // Output incremented value
  end
end

endmodule