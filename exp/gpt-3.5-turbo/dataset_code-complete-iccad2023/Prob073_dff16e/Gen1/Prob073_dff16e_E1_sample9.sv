module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  reg [15:0] q_reg; // Internal register to hold the values

  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      q_reg <= 16'b0;
    end else begin
      q_reg <= (byteena[1] & 16'b1111111100000000) | (byteena[0] & 16'b0000000011111111) | (d & ~(byteena[1] | byteena[0]));
    end
  end

  assign q = q_reg;

endmodule