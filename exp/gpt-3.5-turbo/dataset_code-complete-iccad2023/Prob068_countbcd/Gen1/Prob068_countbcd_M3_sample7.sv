module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [3:0] ones = 4'b0;
reg [3:0] tens = 4'b0;
reg [3:0] hundreds = 4'b0;
reg [3:0] thousands = 4'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
        thousands <= 4'b0;
        ena <= 3'b0;
        q <= 16'b0;
    end else begin
        // Ones digit counter increment and wrap around
        if (ones == 4'b1001)
            ones <= 4'b0;
        else
            ones <= ones + 1;

        // Tens digit counter condition
        if (ones == 4'b1001) begin
            if (tens == 4'b1001)
                tens <= 4'b0;
            else
                tens <= tens + 1;
        end

        // Hundreds digit counter condition
        if (ones == 4'b1001 && tens == 4'b1001) begin
            if (hundreds == 4'b1001)
                hundreds <= 4'b0;
            else
                hundreds <= hundreds + 1;
        end

        // Thousands digit counter condition
        if (ones == 4'b1001 && tens == 4'b1001 && hundreds == 4'b1001)
            thousands <= thousands + 1;

        // Set enable signals based on digit about to be incremented
        ena[1] <= (ones == 4'b1001) ? 1 : 0;
        ena[2] <= (ones == 4'b1001 && tens == 4'b1001) ? 1 : 0;
        ena[3] <= (ones == 4'b1001 && tens == 4'b1001 && hundreds == 4'b1001) ? 1 : 0;

        // Combine BCD digits
        q = {thousands, hundreds, tens, ones};
    end
end

endmodule