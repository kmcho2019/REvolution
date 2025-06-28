module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

reg [7:0] in_prev;

always @(posedge clk) begin
  // Store current input values
  in_prev <= in;
  
  // Detect edge transitions for each bit
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] != in_prev[i]) begin
      anyedge[i] <= 1;
    end else begin
      anyedge[i] <= 0;
    end
  end
end

endmodule