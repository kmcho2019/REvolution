module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to increment BCD digit with max
  function [3:0] bcd_inc;
    input [3:0] digit;
    input [3:0] max_digit;
    begin
      if (digit == max_digit)
        bcd_inc = 4'd0;
      else
        bcd_inc = digit + 4'd1;
    end
  endfunction

  // Helper function to check if BCD digit reached max
  function bcd_eq;
    input [3:0] digit;
    input [3:0] val;
    begin
      bcd_eq = (digit == val);
    end
  endfunction

  // Extract BCD digits
  wire [3:0] ss_ones = ss[3:0];
  wire [3:0] ss_tens = ss[7:4];

  wire [3:0] mm_ones = mm[3:0];
  wire [3:0] mm_tens = mm[7:4];

  wire [3:0] hh_ones = hh[3:0];
  wire [3:0] hh_tens = hh[7:4];

  // Next values for counters
  reg [7:0] ss_next;
  reg [7:0] mm_next;
  reg [7:0] hh_next;
  reg pm_next;

  always @(*) begin
    // Default assignments
    ss_next = ss;
    mm_next = mm;
    hh_next = hh;
    pm_next = pm;

    if (ena) begin
      // Increment seconds
      if ((ss_ones == 4'd9) && (ss_tens == 4'd5)) begin
        // Seconds rollover from 59 to 00
        ss_next = 8'h00;

        // Increment minutes
        if ((mm_ones == 4'd9) && (mm_tens == 4'd5)) begin
          // Minutes rollover from 59 to 00
          mm_next = 8'h00;

          // Increment hours
          // Hours count 01 to 12 BCD
          // Convert current hh to decimal for clarity
          // hh is in BCD: tens*10 + ones
          integer hour_dec;
          hour_dec = hh_tens * 10 + hh_ones;

          if (hour_dec == 12) begin
            // After 12 comes 1
            hh_next = 8'h01; // 0x01 in BCD
            // PM toggles when going from 11 to 12, so here PM stays same
            // PM toggling happens when incrementing from 11 to 12, which is before this
            // So no PM toggle here
          end else if (hour_dec == 11) begin
            // After 11 comes 12
            hh_next = 8'h12;
            pm_next = ~pm;
          end else begin
            // Normal increment of hour
            integer new_hour_dec;
            new_hour_dec = hour_dec + 1;
            // Convert back to BCD
            hh_next[7:4] = (new_hour_dec / 10);
            hh_next[3:0] = (new_hour_dec % 10);
          end

        end else begin
          // Minutes increment normally
          if (mm_ones == 4'd9) begin
            // ones roll over to 0, tens increment by 1
            mm_next[3:0] = 4'd0;
            mm_next[7:4] = mm_tens + 4'd1;
          end else begin
            mm_next[3:0] = mm_ones + 4'd1;
          end
        end
      end else begin
        // Seconds increment normally
        if (ss_ones == 4'd9) begin
          // ones roll over to 0, tens increment by 1
          ss_next[3:0] = 4'd0;
          ss_next[7:4] = ss_tens + 4'd1;
        end else begin
          ss_next[3:0] = ss_ones + 4'd1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      pm <= 1'b0; // AM
      hh <= 8'h12; // 12 in BCD
      mm <= 8'h00;
      ss <= 8'h00;
    end else begin
      pm <= pm_next;
      hh <= hh_next;
      mm <= mm_next;
      ss <= ss_next;
    end
  end

endmodule