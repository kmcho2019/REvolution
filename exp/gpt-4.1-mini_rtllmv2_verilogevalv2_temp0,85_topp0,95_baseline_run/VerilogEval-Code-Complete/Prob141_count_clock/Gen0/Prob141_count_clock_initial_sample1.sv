module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to increment BCD digit (0-9)
  function [3:0] bcd_inc;
    input [3:0] digit;
    begin
      if (digit == 4'd9)
        bcd_inc = 4'd0;
      else
        bcd_inc = digit + 4'd1;
    end
  endfunction

  // Helper function to check if BCD digit is 9
  function bcd_is_9;
    input [3:0] digit;
    begin
      bcd_is_9 = (digit == 4'd9);
    end
  endfunction

  // Check if seconds = 59 (BCD)
  function sec_is_59;
    input [7:0] sec;
    begin
      sec_is_59 = (sec[7:4] == 4'd5) && (sec[3:0] == 4'd9);
    end
  endfunction

  // Check if minutes = 59 (BCD)
  function min_is_59;
    input [7:0] min;
    begin
      min_is_59 = (min[7:4] == 4'd5) && (min[3:0] == 4'd9);
    end
  endfunction

  // Check if hours = 12 (BCD)
  function hour_is_12;
    input [7:0] hour;
    begin
      hour_is_12 = (hour[7:4] == 4'd1) && (hour[3:0] == 4'd2);
    end
  endfunction

  // Increment BCD seconds
  task increment_seconds;
    output [7:0] sec_out;
    output sec_rollover;
    reg [3:0] ones, tens;
    begin
      ones = ss[3:0];
      tens = ss[7:4];
      if (sec_is_59(ss)) begin
        sec_out = 8'h00; // 00 seconds
        sec_rollover = 1'b1;
      end else begin
        sec_rollover = 1'b0;
        if (ones == 4'd9) begin
          ones = 4'd0;
          tens = tens + 4'd1;
        end else begin
          ones = ones + 4'd1;
        end
        sec_out = {tens, ones};
      end
    end
  endtask

  // Increment BCD minutes
  task increment_minutes;
    input [7:0] min_in;
    output [7:0] min_out;
    output min_rollover;
    reg [3:0] ones, tens;
    begin
      ones = min_in[3:0];
      tens = min_in[7:4];
      if (min_is_59(min_in)) begin
        min_out = 8'h00; // 00 minutes
        min_rollover = 1'b1;
      end else begin
        min_rollover = 1'b0;
        if (ones == 4'd9) begin
          ones = 4'd0;
          tens = tens + 4'd1;
        end else begin
          ones = ones + 4'd1;
        end
        min_out = {tens, ones};
      end
    end
  endtask

  // Increment hours (12-hour BCD)
  task increment_hours;
    input [7:0] hour_in;
    input pm_in;
    output [7:0] hour_out;
    output pm_out;
    reg [3:0] ones, tens;
    reg toggle_pm;
    begin
      ones = hour_in[3:0];
      tens = hour_in[7:4];
      // Hour ranges 01-12 (BCD)
      // Increment hours with wrap:
      // 01 -> 02 ... 10 -> 11 -> 12 -> 01
      // Toggle PM when wrapping from 11 to 12 (or 12 to 1)
      toggle_pm = 1'b0;

      if (hour_is_12(hour_in)) begin
        // If current hour is 12, next is 01, toggle pm
        hour_out = 8'h01;
        toggle_pm = 1'b1;
      end else begin
        // increment hour by 1 BCD
        if (ones == 4'd9) begin
          ones = 4'd0;
          tens = tens + 4'd1;
        end else begin
          ones = ones + 4'd1;
        end
        hour_out = {tens, ones};
        toggle_pm = 1'b0;
      end

      // When hour goes from 11 to 12, toggle pm also
      // So detect if hour changed from 11 to 12
      // 11 in BCD is 0x11
      if (hour_in == 8'h11 && hour_out == 8'h12)
        toggle_pm = 1'b1;

      pm_out = pm_in ^ toggle_pm;
    end
  endtask

  reg sec_rollover;
  reg min_rollover;
  reg [7:0] new_ss, new_mm, new_hh;
  reg new_pm;

  always @(posedge clk) begin
    if (reset) begin
      // reset synchronous, highest priority
      ss <= 8'h00;
      mm <= 8'h00;
      hh <= 8'h12; // 12
      pm <= 1'b0;  // AM
    end else if (ena) begin
      // increment seconds
      increment_seconds(new_ss, sec_rollover);

      if (sec_rollover) begin
        // increment minutes
        increment_minutes(mm, new_mm, min_rollover);
        if (min_rollover) begin
          // increment hours
          increment_hours(hh, pm, new_hh, new_pm);
          hh <= new_hh;
          pm <= new_pm;
        end else begin
          new_hh = hh;
          new_pm = pm;
        end

        mm <= new_mm;
      end

      ss <= new_ss;
    end
  end

endmodule