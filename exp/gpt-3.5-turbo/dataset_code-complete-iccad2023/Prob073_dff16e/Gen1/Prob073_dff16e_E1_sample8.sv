module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [15:0] reg_file;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    reg_file <= 16'b0; // Reset all flip-flops
  end else begin
    // Use bitwise AND with byteena to select portions of d during write
    reg_file = ((~byteena[1] & ~byteena[0]) & reg_file) | (byteena[1] & d[15:8]) | (byteena[0] & d[7:0]);
  end
end

assign q = reg_file;

endmodule