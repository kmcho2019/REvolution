module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

// Define the state register to track the number of consecutive 'a' low cycles
reg [2:0] a_low_count;

// Define the counter logic
always @ (posedge clk) begin
  if (a == 1) begin
    if (a_low_count == 3'd0) begin
      if (q < 3'd6) // Counter should increment up to 6
        q <= q + 1;
    end
  end else begin
    a_low_count <= a_low_count + 1;
    if (a_low_count == 3'd2) // Reset the counter when 'a' is low for 3 consecutive clock cycles
      q <= 3'd0;
  end
end

endmodule