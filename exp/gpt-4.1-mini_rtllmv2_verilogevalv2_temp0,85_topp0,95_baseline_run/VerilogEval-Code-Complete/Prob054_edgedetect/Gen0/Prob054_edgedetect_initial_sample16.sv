module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;
  reg [7:0] detected;

  always @(posedge clk) begin
    detected <= (~prev_in) & in; // detect 0->1 transitions on each bit
    pedge <= detected;           // output the detected transitions one cycle later
    prev_in <= in;               // store current input for next comparison
  end

endmodule