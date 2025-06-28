module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
  // Detect and store the transitions from 0 to 1 in the input signal
  for (int i=0; i<8; i=i+1) begin
    if (in[i] & !prev_in[i]) begin
      // Set the output bit one cycle after the transition
      #1 pedge[i] <= 1;
    end
  end
  
  // Update the previous input values
  prev_in <= in;
end

endmodule