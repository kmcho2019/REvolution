module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] sequence_detected;
reg [2:0] sequence_check;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    sequence_check <= 3'b0; // Reset the sequence check
    start_shifting <= 0; // Reset start shifting flag
  end
  else begin
    sequence_check <= {sequence_check[1:0], data}; // Shift in the new data bit
    
    if (sequence_detected == 4'b1101) begin
      start_shifting <= 1; // Start shifting when complete sequence detected
    end
    else begin
      if (sequence_check == 3'b110) begin
        sequence_detected <= sequence_check; // Update detected sequence
      end
      else if (sequence_check[2:0] == 3'b101) begin
        sequence_detected <= {sequence_detected[2:0], 1'b1}; // Update detected sequence
      end
      else begin
        sequence_detected <= 4'b0; // Reset detected sequence
      end
    end
  end
end

endmodule