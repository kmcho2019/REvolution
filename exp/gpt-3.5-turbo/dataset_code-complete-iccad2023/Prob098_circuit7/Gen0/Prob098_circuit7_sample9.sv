module TopModule (
  input clk,
  input a,
  output reg q
);

reg [1:0] counter;

always @(posedge clk) begin
  if (a == 1'b1) begin
    if (counter == 2'b11)   // If counter is at 3, reset to 0
      counter <= 2'b00;
    else
      counter <= counter + 1; // Increment
  end
  else if (a == 1'b0) begin
    if (counter == 2'b00)   // If counter is at 0, set to 3
      counter <= 2'b11;
    else
      counter <= counter - 1; // Decrement
  end
end

assign q = (counter == 2'b10) ? 1'b1 : 1'b0;  // Output 'q' is high when counter is 2

endmodule