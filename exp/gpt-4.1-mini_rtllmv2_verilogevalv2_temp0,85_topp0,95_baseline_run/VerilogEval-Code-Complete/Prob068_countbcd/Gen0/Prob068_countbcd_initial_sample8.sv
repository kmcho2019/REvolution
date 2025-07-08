module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  // Internal wires for each digit
  reg [3:0] digit0, digit1, digit2, digit3;

  always @(posedge clk) begin
    if (reset) begin
      digit0 <= 4'd0;
      digit1 <= 4'd0;
      digit2 <= 4'd0;
      digit3 <= 4'd0;
      ena <= 3'b000;
    end else begin
      // Increment ones digit
      if (digit0 == 4'd9) begin
        digit0 <= 4'd0;
        ena[1] <= 1'b1;  // Enable increment of digit1
      end else begin
        digit0 <= digit0 + 1;
        ena[1] <= 1'b0;
      end

      // Increment tens digit if enabled
      if (ena[1]) begin
        if (digit1 == 4'd9) begin
          digit1 <= 4'd0;
          ena[2] <= 1'b1;  // Enable increment of digit2
        end else begin
          digit1 <= digit1 + 1;
          ena[2] <= 1'b0;
        end
      end else begin
        ena[2] <= 1'b0;
      end

      // Increment hundreds digit if enabled
      if (ena[2]) begin
        if (digit2 == 4'd9) begin
          digit2 <= 4'd0;
          ena[3] <= 1'b1;  // Enable increment of digit3
        end else begin
          digit2 <= digit2 + 1;
          ena[3] <= 1'b0;
        end
      end else begin
        ena[3] <= 1'b0;
      end

      // Increment thousands digit if enabled
      if (ena[3]) begin
        if (digit3 == 4'd9) begin
          digit3 <= 4'd0;  // Rolls over after 9999 to 0000
        end else begin
          digit3 <= digit3 + 1;
        end
      end
    end
    // Assign output q
    q <= {digit3, digit2, digit1, digit0};
  end

endmodule