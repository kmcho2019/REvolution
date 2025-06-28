module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [15:0] d_reg;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    d_reg <= 16'b0; // Reset all flip-flops
  end else begin
    // Update the specific parts of the registers based on the byte enable signals using bitwise operations
    d_reg = (byteena[1] & 8'hFF) | (byteena[0] & 8'h00) | ((~byteena[1] & ~byteena[0]) & d_reg);
    d_reg = (byteena[1] & (8'b00001111_11110000 & d)) | (byteena[0] & (8'b11110000_00001111 & d)) | ((~byteena[1] & ~byteena[0]) & d_reg);
  end
end

assign q = d_reg;

endmodule