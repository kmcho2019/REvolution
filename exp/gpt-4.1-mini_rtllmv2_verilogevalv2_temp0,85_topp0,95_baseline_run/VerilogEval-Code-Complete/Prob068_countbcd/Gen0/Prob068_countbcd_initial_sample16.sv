module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  // Extract digits for clarity
  wire [3:0] ones = q[3:0];
  wire [3:0] tens = q[7:4];
  wire [3:0] hundreds = q[11:8];
  wire [3:0] thousands = q[15:12];

  // Internal registers for digits to make updates simpler
  reg [3:0] ones_r, tens_r, hundreds_r, thousands_r;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
      ena <= 3'b000;
      ones_r <= 4'd0;
      tens_r <= 4'd0;
      hundreds_r <= 4'd0;
      thousands_r <= 4'd0;
    end else begin
      // Default ena = 0; will be set later if increment needed
      ena <= 3'b000;

      // Increment ones digit
      if (ones_r == 4'd9) begin
        ones_r <= 4'd0;
        ena[1] <= 1'b1; // Enable tens increment
      end else begin
        ones_r <= ones_r + 1;
      end

      // Increment tens digit if enabled
      if (ena[1]) begin
        if (tens_r == 4'd9) begin
          tens_r <= 4'd0;
          ena[2] <= 1'b1; // Enable hundreds increment
        end else begin
          tens_r <= tens_r + 1;
        end
      end

      // Increment hundreds digit if enabled
      if (ena[2]) begin
        if (hundreds_r == 4'd9) begin
          hundreds_r <= 4'd0;
          ena[3] <= 1'b1; // Enable thousands increment
        end else begin
          hundreds_r <= hundreds_r + 1;
        end
      end

      // Increment thousands digit if enabled
      if (ena[3]) begin
        if (thousands_r == 4'd9) begin
          thousands_r <= 4'd0;
        end else begin
          thousands_r <= thousands_r + 1;
        end
      end

      // Update q with new digits
      q <= {thousands_r, hundreds_r, tens_r, ones_r};
    end
  end

endmodule