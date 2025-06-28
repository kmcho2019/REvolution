module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

always @(posedge clk) begin
  if (~resetn) begin
    q <= 16'b0; // Reset all outputs
  end else begin
    q <= (byteena[1] & d[15:8]) | (byteena[0] & d[7:0]); // Write to q based on byte enables
  end
end

endmodule