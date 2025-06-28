module BCDCounter (
  input clk,
  input reset,
  output reg [2:0] ena,
  output reg [15:0] q
);

reg [3:0] ones_digit, tens_digit, hundreds_digit, thousands_digit;

always @ (posedge clk) begin
  if (reset) begin
    ones_digit <= 4'b0;
    tens_digit <= 4'b0;
    hundreds_digit <= 4'b0;
    thousands_digit <= 4'b0;
  end else begin
    ones_digit <= ones_digit + 1;
    if (ones_digit == 4'b1010) begin
      ones_digit <= 4'b0;
      tens_digit <= tens_digit + 1;
      if (tens_digit == 4'b1010) begin
        tens_digit <= 4'b0;
        hundreds_digit <= hundreds_digit + 1;
        if (hundreds_digit == 4'b1010) begin
          hundreds_digit <= 4'b0;
          thousands_digit <= thousands_digit + 1;
        end
      end
    end
  end

  if (ones_digit == 4'b0001 || ones_digit == 4'b1010) ena[0] <= 1;
  else ena[0] <= 0;

  if (tens_digit == 4'b0001 || tens_digit == 4'b1010) ena[1] <= 1;
  else ena[1] <= 0;

  if (hundreds_digit == 4'b0001 || hundreds_digit == 4'b1010) ena[2] <= 1;
  else ena[2] <= 0;

  q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};
end

endmodule