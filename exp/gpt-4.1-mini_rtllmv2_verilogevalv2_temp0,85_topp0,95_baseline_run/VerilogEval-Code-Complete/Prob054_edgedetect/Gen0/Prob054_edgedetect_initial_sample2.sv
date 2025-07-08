module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    pedge <= (~prev_in) & in;  // set bit if prev_in is 0 and in is 1
    prev_in <= in;
  end

endmodule