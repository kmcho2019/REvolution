module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  // Temporary registers for the next value and enables
  reg [3:0] ones, tens, hundreds, thousands;
  reg en_tens, en_hundreds, en_thousands;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
      ena <= 3'b0;
    end else begin
      // Extract digits from q
      ones     = q[3:0];
      tens     = q[7:4];
      hundreds = q[11:8];
      thousands = q[15:12];

      // Increment ones digit
      if (ones == 9) begin
        ones = 0;
        en_tens = 1;
      end else begin
        ones = ones + 1;
        en_tens = 0;
      end

      // Increment tens digit if enabled
      if (en_tens) begin
        if (tens == 9) begin
          tens = 0;
          en_hundreds = 1;
        end else begin
          tens = tens + 1;
          en_hundreds = 0;
        end
      end else begin
        en_hundreds = 0;
      end

      // Increment hundreds digit if enabled
      if (en_hundreds) begin
        if (hundreds == 9) begin
          hundreds = 0;
          en_thousands = 1;
        end else begin
          hundreds = hundreds + 1;
          en_thousands = 0;
        end
      end else begin
        en_thousands = 0;
      end

      // Increment thousands digit if enabled
      if (en_thousands) begin
        if (thousands == 9) begin
          thousands = 0;
        end else begin
          thousands = thousands + 1;
        end
      end

      // Pack digits back into q
      q <= {thousands, hundreds, tens, ones};

      // Assign enable signals for digits [3:1]
      ena <= {en_thousands, en_hundreds, en_tens};
    end
  end

endmodule