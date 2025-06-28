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
    pm <= 1'b0;
    hours_tens <= 4'b0001; // 12:00 AM
    hours_ones <= 4'b0000;
    minutes_tens <= 4'b0000;
    minutes_ones <= 4'b0000;
    seconds_tens <= 4'b0000;
    seconds_ones <= 4'b0000;
  end else if (ena) begin
    // Increment seconds
    if (seconds_ones == 4'b1001) begin
      seconds_ones <= 4'b0000;
      if (seconds_tens == 4'b0101) begin
        seconds_tens <= 4'b0000;
        // Increment minutes
        if (minutes_ones == 4'b1001) begin
          minutes_ones <= 4'b0000;
          if (minutes_tens == 4'b0101) begin
            minutes_tens <= 4'b0000;
            // Increment hours
            if (hours_ones == 4'b1001) begin
              hours_ones <= 4'b0001; // Reset hours_ones
              if (hours_tens == 4'b0001) begin
                hours_tens <= 4'b0000; // Reset hours_tens to 0
                pm <= ~pm; // Toggle AM/PM
              end else if (hours_tens < 4'b0001) begin
                hours_tens <= hours_tens + 1;
              end
            end else begin
              hours_ones <= hours_ones + 1;
            end
          end else begin
            minutes_tens <= minutes_tens + 1;
          end
        end else begin
          minutes_ones <= minutes_ones + 1;
        end
      end else begin
        seconds_tens <= seconds_tens + 1;
      end
    end else begin
      seconds_ones <= seconds_ones + 1;
    end
  end
end

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

endmodule