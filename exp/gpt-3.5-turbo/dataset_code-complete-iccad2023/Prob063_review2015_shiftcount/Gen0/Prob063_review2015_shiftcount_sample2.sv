module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);

  reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (shift_ena && !count_ena) begin
      // Shift in data when shift_ena is 1
      shift_reg <= {shift_reg[2:0], data};
    end else if (!shift_ena && count_ena) begin
      // Decrement the shift register value when count_ena is 1
      shift_reg <= shift_reg - 1;
    end
  end

  assign q = shift_reg;

endmodule