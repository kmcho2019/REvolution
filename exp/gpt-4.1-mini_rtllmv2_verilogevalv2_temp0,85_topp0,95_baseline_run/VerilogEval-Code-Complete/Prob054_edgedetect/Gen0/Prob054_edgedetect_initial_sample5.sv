module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;
  reg [7:0] transition_detected;

  always @(posedge clk) begin
    // Detect 0->1 transitions on current inputs compared to previous inputs
    transition_detected <= (~prev_in) & in;
    // pedge is set one cycle after the transition occurred
    pedge <= transition_detected;
    // Store current input for next cycle comparison
    prev_in <= in;
  end

endmodule