module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] seq_detect; // Variable to detect the '1101' sequence

always @(posedge clk or posedge reset) begin
  if (reset) begin
    seq_detect <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    seq_detect <= {seq_detect[2:0], data}; // Shift in new data
    if (seq_detect == 4'b1101) begin // Check for sequence '1101'
      start_shifting <= 1;
    end
    else begin
      start_shifting <= start_shifting & ~reset; // If reset, stop shifting
    end
  end
end

endmodule