module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

  reg [7:0] in_prev;

  always @(posedge clk) begin
    anyedge <= in ^ in_prev;  // XOR detects bit changes (edges)
    in_prev <= in;            // Store current input for next cycle
  end

endmodule