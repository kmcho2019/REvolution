module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

  reg [7:0] prev_in;
  reg [7:0] edge_detected;

  always @(posedge clk) begin
    prev_in <= in;
    edge_detected <= in ^ prev_in; // XOR detects any change bitwise
    anyedge <= edge_detected;      // output edge_detected from previous cycle
  end

endmodule