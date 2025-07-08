module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;
  reg [7:0] detected;

  always @(posedge clk) begin
    // Detect 0->1 transitions: prev_in==0 and in==1
    detected <= (~prev_in) & in;

    // Output the detected transitions delayed by one clock cycle
    pedge <= detected;

    // Update prev_in to current input
    prev_in <= in;
  end

endmodule