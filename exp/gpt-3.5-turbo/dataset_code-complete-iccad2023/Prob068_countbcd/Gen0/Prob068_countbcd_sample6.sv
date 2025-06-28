module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

// Instantiate modulo-10 counters for each BCD digit
reg [3:0] ones, tens, hundreds, thousands;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    ones <= 4'b0;
    tens <= 4'b0;
    hundreds <= 4'b0;
    thousands <= 4'b0;
    q <= 16'b0;
    ena <= 3'b0;
  end else begin
    // Ones digit counter
    if (ones == 4'b1001) begin
      ones <= 4'b0;
      ena[1] <= 1;
    end else begin
      ones <= ones + 1;
      ena[1] <= 0;
    end

    // Tens digit counter
    if (ones == 4'b1001) begin
      if (tens == 4'b1001) begin
        tens <= 4'b0;
        ena[2] <= 1;
      end else begin
        tens <= tens + 1;
        ena[2] <= 0;
      end
    end

    // Hundreds digit counter
    if (tens == 4'b1001 && ones == 4'b1001) begin
      if (hundreds == 4'b1001) begin
        hundreds <= 4'b0;
        ena[3] <= 1;
      end else begin
        hundreds <= hundreds + 1;
        ena[3] <= 0;
      end
    end

    // Thousands digit counter
    if (hundreds == 4'b1001 && tens == 4'b1001 && ones == 4'b1001) begin
      thousands <= thousands + 1;
    end

    // Combine digits into BCD representation
    q = {thousands, hundreds, tens, ones};
  end
end

endmodule