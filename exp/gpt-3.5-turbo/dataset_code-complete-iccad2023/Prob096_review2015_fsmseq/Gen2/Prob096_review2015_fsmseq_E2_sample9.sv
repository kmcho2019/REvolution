module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] bits_buffer = 4'b0;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    start_shifting <= 0;
    bits_buffer <= 4'b0;
  end
  else begin
    bits_buffer <= {bits_buffer[2:0], data}; // Shift in the new data bit
    
    case (bits_buffer)
      4'b0000: start_shifting <= 0; // No match
      4'b0110: start_shifting <= 0; // Partial match, reset shifting
      4'b1101: start_shifting <= 1; // Full match, start shifting
      default: start_shifting <= start_shifting; // Continue shifting if not in matching sequence
    endcase
  end
end

endmodule