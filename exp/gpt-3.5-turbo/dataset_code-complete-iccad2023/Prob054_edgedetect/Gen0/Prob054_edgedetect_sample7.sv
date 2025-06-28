module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

reg [7:0] previous_input;
reg [7:0] delayed_output;

always @(posedge clk) begin
  // Detect transition from 0 to 1 and delay setting output to next cycle
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] && !previous_input[i]) // Detect 0 to 1 transition
      delayed_output[i] <= 1;
    else
      delayed_output[i] <= 0;
  end
  
  previous_input <= in;
end

// Assign delayed output to final output
always @(posedge clk) begin
  pedge <= delayed_output;
end

endmodule