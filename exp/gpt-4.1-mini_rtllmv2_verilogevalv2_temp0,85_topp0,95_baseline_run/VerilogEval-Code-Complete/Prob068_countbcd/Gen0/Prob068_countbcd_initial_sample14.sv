module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  // Extract digits from q for clarity
  wire [3:0] ones = q[3:0];
  wire [3:0] tens = q[7:4];
  wire [3:0] hundreds = q[11:8];
  wire [3:0] thousands = q[15:12];

  reg [3:0] ones_next;
  reg [3:0] tens_next;
  reg [3:0] hundreds_next;
  reg [3:0] thousands_next;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
      ena <= 3'b0;
    end else begin
      // Increment ones digit
      if (ones == 4'd9) begin
        ones_next = 4'd0;
        ena[1] = 1'b1; // Enable increment for tens digit
      end else begin
        ones_next = ones + 1;
        ena[1] = 1'b0;
      end

      // Increment tens digit if enabled
      if (ena[1]) begin
        if (tens == 4'd9) begin
          tens_next = 4'd0;
          ena[2] = 1'b1; // Enable increment for hundreds digit
        end else begin
          tens_next = tens + 1;
          ena[2] = 1'b0;
        end
      end else begin
        tens_next = tens;
        ena[2] = 1'b0;
      end

      // Increment hundreds digit if enabled
      if (ena[2]) begin
        if (hundreds == 4'd9) begin
          hundreds_next = 4'd0;
          ena[3] = 1'b1; // Enable increment for thousands digit
        end else begin
          hundreds_next = hundreds + 1;
          ena[3] = 1'b0;
        end
      end else begin
        hundreds_next = hundreds;
        ena[3] = 1'b0;
      end

      // Increment thousands digit if enabled
      if (ena[3]) begin
        if (thousands == 4'd9)
          thousands_next = 4'd0;
        else
          thousands_next = thousands + 1;
      end else begin
        thousands_next = thousands;
      end

      // Update q with new digits
      q <= {thousands_next, hundreds_next, tens_next, ones_next};
    end
  end

endmodule