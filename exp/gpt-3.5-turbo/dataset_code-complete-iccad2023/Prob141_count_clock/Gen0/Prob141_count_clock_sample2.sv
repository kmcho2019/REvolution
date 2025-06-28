module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

reg [3:0] hours_tens, hours_ones;
reg [3:0] minutes_tens, minutes_ones;
reg [3:0] seconds_tens, seconds_ones;

always @(posedge clk) begin
  if (reset) begin
    // Reset to "12:00 AM"
    hh <= 8'b0001_0010; // 12
    mm <= 8'b0000_0000; // 00
    ss <= 8'b0000_0000; // 00
    pm <= 1'b0; // AM
  end else if (ena) begin
    // Increment seconds every second
    if (ss == 8'b0101_1001) begin
      ss <= 8'b0000_0000;
      // Increment minutes
      if (mm == 8'b0101_1001) begin
        mm <= 8'b0000_0000;
        // Increment hours
        if (hours_tens == 8'b0001 && hours_ones == 8'b0001) begin
          hours_tens <= 4'b0000;
          hours_ones <= 4'b0001;
          pm <= ~pm; // Toggle AM/PM
        end else if (hours_ones == 8'b1001) begin
          hours_ones <= 4'b0001;
          hours_tens <= hours_tens + 1;
        end else begin
          hours_ones <= hours_ones + 1;
        end
      end else if (minutes_ones == 8'b1001) begin
        minutes_ones <= 4'b0000;
        minutes_tens <= minutes_tens + 1;
      end else begin
        minutes_ones <= minutes_ones + 1;
      end
    end else if (seconds_ones == 8'b1001) begin
      seconds_ones <= 4'b0000;
      seconds_tens <= seconds_tens + 1;
    end else begin
      seconds_ones <= seconds_ones + 1;
    end
  end
end

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

endmodule