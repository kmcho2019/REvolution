module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

  reg [7:0] prev_in;
  reg [7:0] edge_detected;

  always @(posedge clk) begin
    prev_in <= in;
    edge_detected <= in ^ prev_in;  // Detect edges comparing current and previous inputs
    anyedge <= edge_detected;       // Output edge detected one cycle delayed
  end

endmodule