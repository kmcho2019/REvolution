module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);
  always @(posedge clk) begin
    if (shift_ena) begin
      // Shift left, MSB first, shift in data at LSB
      q <= {q[2:0], data};
    end else if (count_ena) begin
      // Decrement current value
      q <= q - 1;
    end
    // If neither shift_ena nor count_ena is active, hold q
  end
endmodule