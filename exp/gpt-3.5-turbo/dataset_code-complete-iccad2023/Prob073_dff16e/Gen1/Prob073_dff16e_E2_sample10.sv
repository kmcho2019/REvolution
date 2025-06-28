module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

  reg [15:0] q_reg;

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      q_reg <= 16'b0; // Reset all registers to 0
    end else begin
      q_reg <= (byteena[1] & 8'b1111111100000000) | (byteena[0] & 8'b0000000011111111) & d;
    end
  end

  always @* begin
    q = q_reg;
  end

endmodule