module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

  reg [15:0] q_reg;

  always @(posedge clk) begin
    if (~resetn) begin
      q_reg <= 16'b0;
    end else begin
      q_reg = (byteena[1] & 16'b1111000011110000) | // Mask upper byte based on byteena[1]
               (byteena[0] & 16'b0000111100001111) | // Mask lower byte based on byteena[0]
               (~byteena[1] & 16'b0000111111110000) & // Preserve upper byte if not enabled
               (~byteena[0] & 16'b1111000000001111) & // Preserve lower byte if not enabled
               d; // Update with new data
    end
  end

  assign q = q_reg;

endmodule