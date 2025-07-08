module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    pedge <= (prev_in == 8'b0) ? 8'b0 : 8'b0; // this line just to avoid warning (will be overwritten)
    pedge <= (~prev_in) & in;   // set pedge where previous bit was 0 and current is 1 (0->1 transition)
    prev_in <= in;
  end

endmodule