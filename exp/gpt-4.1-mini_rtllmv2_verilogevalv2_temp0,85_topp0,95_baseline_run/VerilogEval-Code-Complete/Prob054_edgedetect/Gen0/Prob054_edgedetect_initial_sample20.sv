module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;
  reg [7:0] detected;  // detected 0->1 transitions this cycle

  always @(posedge clk) begin
    // detect 0->1 transitions: previous bit 0, current bit 1
    detected <= (~prev_in) & in;
    prev_in <= in;
    // output the detected transitions delayed by one cycle
    pedge <= detected;
  end

endmodule