module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

reg [7:0] previous_in;

always @(posedge clk) begin
  for (int i=0; i<8; i=i+1) begin
    if (in[i] != previous_in[i]) begin
      anyedge[i] <= 1; // Set output bit on detecting any edge
    end else begin
      anyedge[i] <= 0;
    end
    previous_in[i] <= in[i];
  end
end

endmodule