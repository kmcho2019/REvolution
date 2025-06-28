module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
  // Iterate over each bit
  for (int i = 0; i < 8; i=i+1) begin
    if (in[i] && !prev_in[i]) begin
      // Rising edge detected, set the output bit in the next clock cycle
      pedge[i] <= 1;
    end else begin
      pedge[i] <= 0;
    end
  end
  
  prev_in <= in; // Update previous input values
end

endmodule