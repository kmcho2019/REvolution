module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] input_history = 4'b0;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    start_shifting <= 0;
    input_history <= 4'b0;
  end
  else begin
    input_history <= {input_history[2:0], data}; // Shift in the new data bit
    
    if (input_history == 4'b1101) begin
      start_shifting <= 1; // Set shifting flag when the complete sequence is detected
    end
    else if (input_history[3:1] == 3'b110) begin
      start_shifting <= 1; // Start shifting when the initial part of the sequence is found
    end
    else begin
      start_shifting <= 0; // Reset shifting flag if sequence is interrupted
    end
  end
end

endmodule