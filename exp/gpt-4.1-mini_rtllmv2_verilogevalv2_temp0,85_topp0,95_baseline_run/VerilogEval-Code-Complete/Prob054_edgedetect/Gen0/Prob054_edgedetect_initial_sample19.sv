module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] in_d;

  always @(posedge clk) begin
    pedge <= (~in_d) & in;  // detect 0->1 transition (previous 0, current 1)
    in_d <= in;
  end

endmodule