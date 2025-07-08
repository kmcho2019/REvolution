module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    anyedge <= prev_in ^ in;  // Detect edges from previous to current input
    prev_in <= in;            // Save current input for next cycle comparison
  end

endmodule