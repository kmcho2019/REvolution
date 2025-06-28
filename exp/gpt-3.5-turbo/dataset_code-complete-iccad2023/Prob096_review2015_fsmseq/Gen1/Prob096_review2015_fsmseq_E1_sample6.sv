module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [2:0] bits_buffer = 3'b0;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    start_shifting <= 0;
    bits_buffer <= 3'b0;
  end
  else begin
    bits_buffer <= {bits_buffer[1:0], data}; // Shift in the new data bit
  
    if (bits_buffer == 3'b110) begin
      start_shifting <= 1; // Start shifting when 110 detected
    end
    else if (bits_buffer == 3'b1101) begin
      start_shifting <= 1; // Set shifting flag if complete sequence found
    end
    else begin
      start_shifting <= 0; // Reset shifting flag if sequence interrupted
    end
  end
end

endmodule