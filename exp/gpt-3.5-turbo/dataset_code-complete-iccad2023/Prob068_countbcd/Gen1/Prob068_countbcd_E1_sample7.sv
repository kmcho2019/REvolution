module TopModule (
  input clk,
  input reset,
  input [3:1] ena,
  output reg [15:0] q
);

reg [15:0] count = 16'b0;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        // Increment counter
        count <= count + 1;

        // Extract individual BCD digits
        reg [3:0] ones_digit = count[3:0];
        reg [3:0] tens_digit = count[7:4];
        reg [3:0] hundreds_digit = count[11:8];
        reg [3:0] thousands_digit = count[15:12];

        // Conditional increment based on enable signals
        if (ena[1])
            tens_digit = (tens_digit == 4'b1001) ? 4'b0000 : tens_digit + 1;
        if (ena[2])
            hundreds_digit = (hundreds_digit == 4'b1001) ? 4'b0000 : hundreds_digit + 1;
        if (ena[3])
            thousands_digit = (thousands_digit == 4'b1001) ? 4'b0000 : thousands_digit + 1;

        // Combine BCD digits
        q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};
    end
end

endmodule