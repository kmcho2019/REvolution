module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] search_progress; // Progress of the search
reg [3:0] desired_sequence = 4'b1101; // Desired sequence to search for

always @(posedge clk or posedge reset) begin
  if (reset) begin
    search_progress <= 4'b0000;
    start_shifting <= 0;
  end
  else begin
    // Update search_progress based on input data and desired sequence
    search_progress <= {search_progress[2:0], (data == desired_sequence[3]) & (search_progress == 4'b110)};
    
    if (search_progress == 4'b1101) begin
      start_shifting <= 1; // Sequence found, set shifting flag
    end
    else if (search_progress == 4'b110) begin
      start_shifting <= 0; // Reset shifting flag on sequence interruption
    end
  end
end

endmodule