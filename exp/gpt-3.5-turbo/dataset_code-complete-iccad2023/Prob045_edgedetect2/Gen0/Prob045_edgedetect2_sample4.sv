module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

reg [7:0] prev_in_reg;
reg [7:0] curr_in_reg;

// Store current input values
always @(posedge clk) begin
  prev_in_reg <= curr_in_reg;
  curr_in_reg <= in;
end

// Detect edge for each bit
always @(posedge clk) begin
  for (int i=0; i<8; i=i+1) begin
    if (curr_in_reg[i] != prev_in_reg[i]) begin
      anyedge[i] <= 1;
    end
  end
end

endmodule