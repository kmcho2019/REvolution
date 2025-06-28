module ShiftRegisterDownCounter (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);

// Internal signals
reg [3:0] shift_reg;

always @(posedge clk) begin
  if (shift_ena) begin
    // Shift register behavior
    shift_reg <= {shift_reg[2:0], data};
  end
  else if (count_ena) begin
    // Down counter behavior
    shift_reg <= shift_reg - 1;
  end
end

assign q = shift_reg;

endmodule