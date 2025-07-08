module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);
  
  // Internal wires for digits
  wire [3:0] ones = q[3:0];
  wire [3:0] tens = q[7:4];
  wire [3:0] hundreds = q[11:8];
  wire [3:0] thousands = q[15:12];

  // Helper function to check if digit is 9
  wire ones_is_9 = (ones == 4'd9);
  wire tens_is_9 = (tens == 4'd9);
  wire hundreds_is_9 = (hundreds == 4'd9);

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
      ena <= 3'b0;
    end else begin
      // Default ena is 0, will set if needed
      ena <= 3'b0;

      // Increment ones digit
      if (ones_is_9) begin
        // ones rolls over to 0
        // Enable tens increment
        ena[1] <= 1'b1;
        
        // Increment tens digit
        if (tens_is_9) begin
          // tens rolls over to 0
          ena[2] <= 1'b1;

          // Increment hundreds digit
          if (hundreds_is_9) begin
            // hundreds rolls over to 0
            ena[3] <= 1'b1;

            // Increment thousands digit with rollover at 9
            if (thousands == 4'd9) begin
              q <= 16'b0;  // roll over entire counter to 0000
            end else begin
              q[15:12] <= thousands + 4'd1;
              q[11:0] <= 12'b0;  // reset lower digits after carry
            end
          end else begin
            // hundreds increments by 1
            q[11:8] <= hundreds + 4'd1;
            q[7:0] <= 8'b0;  // reset tens and ones after carry
          end
        end else begin
          // tens increments by 1
          q[7:4] <= tens + 4'd1;
          q[3:0] <= 4'b0;   // reset ones after carry
        end
      end else begin
        // ones increments by 1, no carry
        q[3:0] <= ones + 4'd1;
      end
    end
  end

endmodule