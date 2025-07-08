module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);
  initial q = 4'b0000;
  always @(posedge clk) begin
    if (shift_ena) begin
      // Shift left by 1, input data at LSB
      q <= {q[2:0], data};
    end else if (count_ena) begin
      q <= q - 1;
    end
  end
endmodule