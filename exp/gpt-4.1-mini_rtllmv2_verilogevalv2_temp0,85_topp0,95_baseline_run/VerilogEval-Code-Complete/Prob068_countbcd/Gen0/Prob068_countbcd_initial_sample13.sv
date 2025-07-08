module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  // Wires for each digit
  wire [3:0] ones = q[3:0];
  wire [3:0] tens = q[7:4];
  wire [3:0] hundreds = q[11:8];
  wire [3:0] thousands = q[15:12];

  // Internal signals to indicate digit rollover
  reg ena_ones_rollover;
  reg ena_tens_rollover;
  reg ena_hundreds_rollover;

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
      ena <= 3'b0;
    end else begin
      // Default disables
      ena <= 3'b0;

      // Increment ones digit
      if (ones == 4'd9) begin
        // ones digit rolls over
        q[3:0] <= 4'd0;
        ena[1] <= 1'b1; // enable tens increment

        // Increment tens digit
        if (tens == 4'd9) begin
          q[7:4] <= 4'd0;
          ena[2] <= 1'b1; // enable hundreds increment

          // Increment hundreds digit
          if (hundreds == 4'd9) begin
            q[11:8] <= 4'd0;
            ena[3] <= 1'b1; // enable thousands increment

            // Increment thousands digit
            if (thousands == 4'd9) begin
              // roll over thousands digit to 0
              q[15:12] <= 4'd0;
            end else begin
              q[15:12] <= thousands + 4'd1;
            end

          end else begin
            q[11:8] <= hundreds + 4'd1;
          end

        end else begin
          q[7:4] <= tens + 4'd1;
        end

      end else begin
        q[3:0] <= ones + 4'd1;
      end
    end
  end

endmodule