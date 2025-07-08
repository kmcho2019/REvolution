module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);
  reg [7:0] prev_in;
  reg [7:0] transition;

  always @(posedge clk) begin
    prev_in <= in;
    transition <= (~prev_in) & in;  // detect 0->1 transition
    pedge <= transition;            // output set cycle after transition
  end
endmodule