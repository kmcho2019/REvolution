module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to increment BCD digit with max 9
  function [3:0] bcd_increment_9;
    input [3:0] digit;
    begin
      if (digit == 4'd9)
        bcd_increment_9 = 4'd0;
      else
        bcd_increment_9 = digit + 1;
    end
  endfunction

  // Helper function to check if BCD digit is 9
  function bcd_is_9;
    input [3:0] digit;
    begin
      bcd_is_9 = (digit == 4'd9);
    end
  endfunction

  // Helper function to increment seconds or minutes BCD (00-59)
  // Returns {new_bcd, rollover}
  function [8:0] bcd_inc_59;
    input [7:0] bcd;
    reg [3:0] ones, tens;
    reg rollover_ones, rollover_tens;
    reg [7:0] new_bcd;
    reg rollover;
    begin
      ones = bcd[3:0];
      tens = bcd[7:4];
      // increment ones digit
      if (ones == 4'd9) begin
        ones = 4'd0;
        // increment tens digit
        if (tens == 4'd5) begin
          tens = 4'd0;
          rollover = 1'b1;
        end else begin
          tens = tens + 1;
          rollover = 1'b0;
        end
      end else begin
        ones = ones + 1;
        rollover = 1'b0;
      end
      new_bcd = {tens, ones};
      bcd_inc_59 = {rollover, new_bcd};
    end
  endfunction

  // Helper function to increment hours in BCD 12-hour format (01-12)
  // Returns {new_bcd, rollover_pm_toggle}
  // hours: 8-bit BCD digits (tens, ones)
  // rollover_pm_toggle: goes high when hour rolls from 11 to 12 (PM toggling point)
  function [8:0] bcd_inc_12h;
    input [7:0] hours;
    reg [3:0] ones, tens;
    reg [7:0] new_hours;
    reg toggle_pm;
    begin
      ones = hours[3:0];
      tens = hours[7:4];
      toggle_pm = 1'b0;

      // Hour increments from 1 to 12
      // If currently 12, next is 1
      if (tens == 4'd1 && ones == 4'd2) begin
        // Wrap around 12 -> 1
        new_hours = 8'b0000_0001; // 01
        toggle_pm = 1'b0; // PM toggling happens at 11->12 transition, not 12->1
      end else if (tens == 4'd0 && ones == 4'd9) begin
        // 09 -> 10
        new_hours = 8'b0001_0000; // 10
        toggle_pm = 1'b0;
      end else if (tens == 4'd0) begin
        // 0x -> increment ones digit
        new_hours = {tens, ones + 1};
        toggle_pm = 1'b0;
      end else if (tens == 4'd1 && ones == 4'd1) begin
        // 11 -> 12: toggle PM
        new_hours = 8'b0001_0010; // 12
        toggle_pm = 1'b1;
      end else begin
        // Should not occur for valid hours, but keep as fallback
        new_hours = hours;
        toggle_pm = 1'b0;
      end

      bcd_inc_12h = {toggle_pm, new_hours};
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh <= 8'b0001_0010; // 12
      mm <= 8'b0000_0000; // 00
      ss <= 8'b0000_0000; // 00
      pm <= 1'b0;         // AM
    end else if (ena) begin
      // increment seconds
      reg [8:0] sec_res;
      reg [8:0] min_res;
      reg [8:0] hr_res;
      reg toggle_pm_local;

      sec_res = bcd_inc_59(ss);
      ss <= sec_res[7:0];
      if (sec_res[8]) begin
        // second rollover, increment minutes
        min_res = bcd_inc_59(mm);
        mm <= min_res[7:0];
        if (min_res[8]) begin
          // minute rollover, increment hour
          hr_res = bcd_inc_12h(hh);
          hh <= hr_res[7:0];
          if (hr_res[8]) begin
            // toggle pm on 11->12 transition
            pm <= ~pm;
          end
        end
      end
    end
  end

endmodule