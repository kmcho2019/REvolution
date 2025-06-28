module BCD_Counter (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

parameter DIGIT_WIDTH = 4;
parameter THRESHOLD_TENS = 2;
parameter THRESHOLD_HUNDREDS = 5;
parameter THRESHOLD_THOUSANDS = 9;

reg [3:0] ones_digit, tens_digit, hundreds_digit, thousands_digit;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    ones_digit <= 4'b0;
    tens_digit <= 4'b0;
    hundreds_digit <= 4'b0;
    thousands_digit <= 4'b0;
    q <= 16'b0;
  end else begin
    // Ones digit
    if (ones_digit == 4'b1001) begin
      ones_digit <= 4'b0;
      if (tens_digit == THRESHOLD_TENS) begin
        tens_digit <= 4'b0;
        if (hundreds_digit == THRESHOLD_HUNDREDS) begin
          hundreds_digit <= 4'b0;
          if (thousands_digit == THRESHOLD_THOUSANDS)
            thousands_digit <= 4'b0;
          else
            thousands_digit <= thousands_digit + 1;
        end else
          hundreds_digit <= hundreds_digit + 1;
      end else
        tens_digit <= tens_digit + 1;
    end else
      ones_digit <= ones_digit + 1;

    // Enable signals for upper three digits
    ena[1] = tens_digit == THRESHOLD_TENS || tens_digit == 1;
    ena[2] = hundreds_digit == THRESHOLD_HUNDREDS || hundreds_digit == 1;
    ena[3] = thousands_digit == THRESHOLD_THOUSANDS || thousands_digit == 1;

    // Combine digits for the final output
    q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};
  end
end

endmodule