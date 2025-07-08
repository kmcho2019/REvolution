module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    // Detect positive edges by comparing current input with previous
    pedge <= in & ~prev_in;
    // Store current input for next cycle comparison
    prev_in <= in;
  end

endmodule