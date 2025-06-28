module TopModule (
  input clk,
  input reset,
  output reg [9:0] q
);

// Internal signal to keep track of the counter value
reg [9:0] counter;

always @(posedge clk) begin
  if (reset) begin
    counter <= 10'b0; // Reset the counter to 0
  end 
  else begin
    if (counter == 10'd999) begin
      counter <= 10'b0; // Reset the counter to 0 when it reaches 999
    end 
    else begin
      counter <= counter + 1; // Increment the counter by 1
    end
  end
end

assign q = counter;

endmodule