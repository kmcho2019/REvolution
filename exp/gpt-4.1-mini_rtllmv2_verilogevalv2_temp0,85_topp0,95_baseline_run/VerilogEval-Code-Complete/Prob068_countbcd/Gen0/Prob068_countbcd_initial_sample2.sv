module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);
  // Internal wires to hold next digit values
  reg [3:0] digit0, digit1, digit2, digit3;
  reg ena1, ena2, ena3;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
      ena <= 3'd0;
    end else begin
      // Extract current digits
      digit0 = q[3:0];
      digit1 = q[7:4];
      digit2 = q[11:8];
      digit3 = q[15:12];

      // Increment ones digit
      if (digit0 == 9) begin
        digit0 = 0;
        ena1 = 1; // Enable tens digit increment
      end else begin
        digit0 = digit0 + 1;
        ena1 = 0;
      end

      // Increment tens digit if enabled
      if (ena1) begin
        if (digit1 == 9) begin
          digit1 = 0;
          ena2 = 1; // Enable hundreds digit increment
        end else begin
          digit1 = digit1 + 1;
          ena2 = 0;
        end
      end else begin
        ena2 = 0;
      end

      // Increment hundreds digit if enabled
      if (ena2) begin
        if (digit2 == 9) begin
          digit2 = 0;
          ena3 = 1; // Enable thousands digit increment
        end else begin
          digit2 = digit2 + 1;
          ena3 = 0;
        end
      end else begin
        ena3 = 0;
      end

      // Increment thousands digit if enabled
      if (ena3) begin
        if (digit3 == 9) begin
          digit3 = 0;
          // No higher digit enable
        end else begin
          digit3 = digit3 + 1;
        end
      end

      // Pack digits back to output
      q <= {digit3, digit2, digit1, digit0};
      ena <= {ena3, ena2, ena1};
    end
  end
endmodule