module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  reg [3:0] ones_digit, tens_digit, hundreds_digit, thousands_digit;

  always @(posedge clk) begin
    if (reset) begin
      ones_digit <= 4'b0000;
      tens_digit <= 4'b0000;
      hundreds_digit <= 4'b0000;
      thousands_digit <= 4'b0000;
    end else begin
      ones_digit <= ones_digit + 1;
      if (ena[1])
        tens_digit <= tens_digit + 1;
      if (ena[2])
        hundreds_digit <= hundreds_digit + 1;
      if (ena[3])
        thousands_digit <= thousands_digit + 1;
    end
  end

  assign q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};
  
endmodule