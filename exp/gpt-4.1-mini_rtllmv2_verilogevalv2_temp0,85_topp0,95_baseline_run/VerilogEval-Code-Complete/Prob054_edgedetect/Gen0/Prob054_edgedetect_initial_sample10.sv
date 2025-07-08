module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;
  reg [7:0] detected_edge;

  always @(posedge clk) begin
    detected_edge <= (~prev_in) & in;  // Detect 0->1 transitions on each bit
    pedge <= detected_edge;            // Output the detected edges from previous cycle
    prev_in <= in;                     // Store current input for next cycle comparison
  end

endmodule