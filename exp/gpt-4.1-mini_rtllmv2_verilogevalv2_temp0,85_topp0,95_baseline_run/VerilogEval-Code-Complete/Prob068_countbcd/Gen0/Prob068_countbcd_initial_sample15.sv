module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  // Internal wires for individual digits
  wire [3:0] digit0, digit1, digit2, digit3;
  wire carry0, carry1, carry2;

  assign digit0 = q[3:0];
  assign digit1 = q[7:4];
  assign digit2 = q[11:8];
  assign digit3 = q[15:12];

  // Enable signals for digits 1 to 3 indicate when the lower digit overflows from 9 to 0
  // This is when that digit reaches 9 and increments again (overflow)
  // So carry signals are generated when digit == 9 and incremented.
  // We'll create carry signals by detecting digit == 9 and increment.

  // For counting BCD digit:
  // If digit < 9, next digit = digit + 1
  // else next digit = 0 and generate carry

  // carry0: ones digit overflow enable tens digit
  assign carry0 = (digit0 == 4'd9);
  // carry1: tens digit overflow enable hundreds digit
  assign carry1 = (digit1 == 4'd9) & ena[1];
  // carry2: hundreds digit overflow enable thousands digit
  assign carry2 = (digit2 == 4'd9) & ena[2];

  // ena signals correspond to when digit increments
  // digit 1 increments when digit0 overflows
  // digit 2 increments when digit1 overflows
  // digit 3 increments when digit2 overflows

  assign ena[1] = carry0;
  assign ena[2] = carry1;
  assign ena[3] = carry2;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
    end else begin
      // Increment ones digit
      if (digit0 == 4'd9)
        q[3:0] <= 4'd0;
      else
        q[3:0] <= digit0 + 4'd1;

      // Increment tens digit if enabled
      if (ena[1]) begin
        if (digit1 == 4'd9)
          q[7:4] <= 4'd0;
        else
          q[7:4] <= digit1 + 4'd1;
      end

      // Increment hundreds digit if enabled
      if (ena[2]) begin
        if (digit2 == 4'd9)
          q[11:8] <= 4'd0;
        else
          q[11:8] <= digit2 + 4'd1;
      end

      // Increment thousands digit if enabled
      if (ena[3]) begin
        if (digit3 == 4'd9)
          q[15:12] <= 4'd0;
        else
          q[15:12] <= digit3 + 4'd1;
      end
    end
  end

endmodule