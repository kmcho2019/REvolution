module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

reg [3:0] hours_tens, hours_ones, minutes_tens, minutes_ones, seconds_tens, seconds_ones;

always @(posedge clk) begin
  if (reset) begin
    // Reset to "12:00 AM"
    pm <= 0;
    hh <= 8'b0001; // 12 in BCD
    mm <= 8'b0000; // 00 in BCD
    ss <= 8'b0000; // 00 in BCD
  end else if (ena) begin
    // Update seconds
    if (ss == 8'b0101) begin
      ss <= 8'b0000; // reset seconds
      // Update minutes
      if (minutes_ones == 8'b1001) begin
        minutes_ones <= 8'b0000; // reset ones
        minutes_tens <= minutes_tens + 1; // increment tens
        // Update hours
        if ((hours_tens == 8'b0010 && hours_ones == 8'b0010) || // 12
            (hours_tens == 8'b0001 && hours_ones == 8'b0010)) begin // 09
          hours_tens <= 8'b0001; // reset tens
          hours_ones <= 8'b0000; // reset ones
          pm <= ~pm; // toggle AM/PM
        end else if (hours_ones == 8'b1001) begin
          hours_ones <= 8'b0000; // reset ones
          hours_tens <= hours_tens + 1; // increment tens
        end else begin
          hours_ones <= hours_ones + 1; // increment ones
        end
      end else if (minutes_ones == 8'b0011 && minutes_tens == 8'b0101) begin // 59
        minutes_ones <= 8'b0000; // reset ones
        minutes_tens <= 8'b0000; // reset tens
      end else if (minutes_ones == 8'b1001) begin
        minutes_ones <= 8'b0000; // reset ones
        minutes_tens <= minutes_tens + 1; // increment tens
      end else begin
        minutes_ones <= minutes_ones + 1; // increment ones
      end
    end else if (ss == 8'b1001) begin // 59
        ss <= 8'b0000; // reset ones
      seconds_tens <= seconds_tens + 1; // increment tens
    end else begin
      ss <= ss + 1; // increment seconds
    end
  end
end

endmodule