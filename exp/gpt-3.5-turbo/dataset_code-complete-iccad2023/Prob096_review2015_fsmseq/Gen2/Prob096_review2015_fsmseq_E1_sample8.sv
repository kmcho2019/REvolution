module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] buffer [0:3]; // Circular buffer to store last 4 bits
reg [3:0] sequence = 4'b1101; // Sequence to detect

always @(posedge clk or posedge reset) begin
  if (reset)
    start_shifting <= 0;

  // Shift in new data into buffer
  for (int i = 3; i > 0; i = i - 1) begin
    buffer[i] <= buffer[i-1];
  end
  buffer[0] <= data;

  // Compare buffer with sequence to detect
  if (buffer == sequence)
    start_shifting <= 1; // Set shifting flag
end

endmodule