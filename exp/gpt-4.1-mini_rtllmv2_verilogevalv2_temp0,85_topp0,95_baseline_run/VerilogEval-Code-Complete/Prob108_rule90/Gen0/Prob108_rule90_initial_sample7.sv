module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [513:0] extended; // zero-padded on both ends

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      extended = {1'b0, q, 1'b0};
      // Each next cell = XOR of left and right neighbors
      q <= extended[512:1] ^ extended[514:3];
    end
  end
endmodule