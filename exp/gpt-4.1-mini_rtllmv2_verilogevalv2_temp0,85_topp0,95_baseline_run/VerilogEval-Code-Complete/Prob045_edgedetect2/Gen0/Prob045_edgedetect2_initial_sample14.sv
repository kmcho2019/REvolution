module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    anyedge <= prev_in ^ in;  // xor to detect edges
    prev_in <= in;
  end

endmodule