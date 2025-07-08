module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);
  reg [7:0] in_d;        // delayed input
  reg [7:0] pedge_next;  // next cycle pedge detection

  always @(posedge clk) begin
    in_d <= in;
    pedge_next <= (~in_d) & in; // detect 0->1 transitions on current cycle
    pedge <= pedge_next;        // output set the cycle after detection
  end
endmodule