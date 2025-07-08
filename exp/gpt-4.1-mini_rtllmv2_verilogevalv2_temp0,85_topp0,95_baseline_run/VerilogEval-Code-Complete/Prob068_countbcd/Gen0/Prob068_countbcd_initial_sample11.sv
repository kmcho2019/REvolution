module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  // Internal wires for each digit
  wire [3:0] ones, tens, hundreds, thousands;
  reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;

  assign ones = q[3:0];
  assign tens = q[7:4];
  assign hundreds = q[11:8];
  assign thousands = q[15:12];

  always @(*) begin
    // Default next states to current values
    ones_next = ones;
    tens_next = tens;
    hundreds_next = hundreds;
    thousands_next = thousands;

    // Default ena to 0
    ena = 3'b000;

    // Increment ones digit
    if (ones == 4'd9) begin
      ones_next = 4'd0;
      ena[1] = 1'b1; // Enable tens increment
      // Now increment tens digit
      if (tens == 4'd9) begin
        tens_next = 4'd0;
        ena[2] = 1'b1; // Enable hundreds increment
        // Increment hundreds digit
        if (hundreds == 4'd9) begin
          hundreds_next = 4'd0;
          ena[3] = 1'b1; // Enable thousands increment
          // Increment thousands digit
          if (thousands == 4'd9) begin
            thousands_next = 4'd0; // Roll over thousands to 0
          end else begin
            thousands_next = thousands + 1'b1;
          end
        end else begin
          hundreds_next = hundreds + 1'b1;
        end
      end else begin
        tens_next = tens + 1'b1;
      end
    end else begin
      // Just increment ones digit
      ones_next = ones + 1'b1;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
    end else begin
      q <= {thousands_next, hundreds_next, tens_next, ones_next};
    end
  end

endmodule