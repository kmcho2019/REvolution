module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Function to increment BCD digits (tens and ones)
  function [7:0] bcd_inc_0to9(input [7:0] bcd);
    reg [3:0] tens, ones;
  begin
    tens = bcd[7:4];
    ones = bcd[3:0];
    if (ones == 4'd9) begin
      ones = 4'd0;
      tens = tens + 1;
    end else begin
      ones = ones + 1;
    end
    bcd_inc_0to9 = {tens, ones};
  end
  endfunction

  // Function to increment seconds or minutes (00-59)
  function [7:0] bcd_inc_00to59(input [7:0] bcd);
    reg [3:0] tens, ones;
  begin
    tens = bcd[7:4];
    ones = bcd[3:0];
    if (ones == 4'd9) begin
      ones = 4'd0;
      if (tens == 4'd5)
        tens = 4'd0; // roll over 59->00
      else
        tens = tens + 1;
    end else begin
      ones = ones + 1;
    end
    bcd_inc_00to59 = {tens, ones};
  end
  endfunction

  // Function to compare BCD to decimal
  function bcd_eq(input [7:0] bcd, input [7:0] dec);
  begin
    bcd_eq = (bcd == dec);
  end
  endfunction

  // Compare BCD digits to decimal values
  wire seconds_59 = (ss == 8'h59);
  wire minutes_59 = (mm == 8'h59);
  wire hours_11 = (hh == 8'h11);
  wire hours_12 = (hh == 8'h12);
  wire hours_01 = (hh == 8'h01);

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh <= 8'h12; // 12
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 1'b0; // AM
    end else if (ena) begin
      // Increment seconds
      if (seconds_59) begin
        ss <= 8'h00;
        // Increment minutes
        if (minutes_59) begin
          mm <= 8'h00;
          // Increment hours in 12-hour format (01-12)
          if (hours_12) begin
            hh <= 8'h01;
            pm <= ~pm; // Toggle am/pm at rollover from 12->1
          end else begin
            // increment hour by 1
            // increment BCD hour with special logic for 09->10
            if (hh[3:0] == 4'd9) begin
              // ones digit 9 -> roll to 0 and tens digit +1
              hh <= {hh[7:4] + 4'd1, 4'd0};
            end else begin
              hh <= {hh[7:4], hh[3:0] + 4'd1};
            end
          end
        end else begin
          mm <= bcd_inc_00to59(mm);
        end
      end else begin
        ss <= bcd_inc_00to59(ss);
      end
    end
  end

endmodule