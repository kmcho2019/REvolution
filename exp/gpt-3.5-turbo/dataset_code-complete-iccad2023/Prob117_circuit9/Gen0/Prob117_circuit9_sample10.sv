module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

// Define an internal register to hold the current state of the counter
reg [2:0] counter = 0;

// Always block triggered by the rising edge of the clock
always @(posedge clk) begin
  if (a == 1) begin
    if (counter == 7)
      counter <= 0; // Wrap around
    else
      counter <= counter + 1;
  end
end

// Assign the output q to the counter value
always @* begin
  q = counter;
end

endmodule