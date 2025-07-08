module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;
  reg [7:0] detected;

  always @(posedge clk) begin
    // Detect 0->1 transition: prev_in bit is 0 and current in bit is 1
    detected <= (~prev_in) & in;
    // Output the detection the cycle after the transition
    pedge <= detected;
    // Store current input for next cycle comparison
    prev_in <= in;
  end

endmodule