module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);
  // q[3:0]   - ones digit
  // q[7:4]   - tens digit
  // q[11:8]  - hundreds digit
  // q[15:12] - thousands digit

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'd0;
      ena <= 3'b0;
    end else begin
      // Default enables low
      ena <= 3'b0;

      // Extract digits
      reg [3:0] ones, tens, hundreds, thousands;
      ones     = q[3:0];
      tens     = q[7:4];
      hundreds = q[11:8];
      thousands= q[15:12];

      // Increment ones digit
      if (ones == 4'd9) begin
        ones <= 4'd0;
        ena[1] <= 1'b1; // enable tens digit
      end else begin
        ones <= ones + 1;
      end

      // Increment tens digit if enabled
      if (ena[1]) begin
        if (tens == 4'd9) begin
          tens <= 4'd0;
          ena[2] <= 1'b1; // enable hundreds digit
        end else begin
          tens <= tens + 1;
        end
      end

      // Increment hundreds digit if enabled
      if (ena[2]) begin
        if (hundreds == 4'd9) begin
          hundreds <= 4'd0;
          ena[3] <= 1'b1; // enable thousands digit
        end else begin
          hundreds <= hundreds + 1;
        end
      end

      // Increment thousands digit if enabled
      if (ena[3]) begin
        if (thousands == 4'd9) begin
          thousands <= 4'd0;
        end else begin
          thousands <= thousands + 1;
        end
      end

      q <= {thousands, hundreds, tens, ones};
    end
  end
endmodule