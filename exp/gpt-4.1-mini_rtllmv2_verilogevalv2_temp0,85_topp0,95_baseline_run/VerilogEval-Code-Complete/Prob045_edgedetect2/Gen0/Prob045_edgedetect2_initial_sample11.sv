module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

  reg [7:0] prev_in;
  reg [7:0] edge_detected;

  always @(posedge clk) begin
    // Detect edges by XORing current input with previous input
    edge_detected <= in ^ prev_in;
    // Store current input for next cycle comparison
    prev_in <= in;
    // Output edge_detected delayed by one clock cycle
    anyedge <= edge_detected;
  end

endmodule