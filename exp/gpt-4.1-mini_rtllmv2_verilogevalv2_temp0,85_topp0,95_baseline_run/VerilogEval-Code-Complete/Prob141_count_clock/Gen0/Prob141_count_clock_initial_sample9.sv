module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // BCD increment helper for 0-9 digit
  function [3:0] bcd_inc_ones;
    input [3:0] digit;
    begin
      if (digit == 4'd9)
        bcd_inc_ones = 4'd0;
      else
        bcd_inc_ones = digit + 1;
    end
  endfunction

  // BCD increment helper for minutes and seconds tens digit (0-5)
  function [3:0] bcd_inc_tens_minsec;
    input [3:0] digit;
    begin
      if (digit == 4'd5)
        bcd_inc_tens_minsec = 4'd0;
      else
        bcd_inc_tens_minsec = digit + 1;
    end
  endfunction

  // BCD increment helper for hours tens digit and ones digit with special rules
  // Hours go from 01 to 12 in BCD: possible tens digits 0 or 1, ones digits 1-9 if tens=0, 0-2 if tens=1.
  // We'll implement increment hour logic separately.

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh <= 8'h12; // 0x12 = 0001 0010 (BCD 12)
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 1'b0; // AM
    end else if (ena) begin
      // Increment seconds
      if (ss[3:0] == 4'd9) begin
        // Ones digit of seconds rolls over
        if (ss[7:4] == 4'd5) begin
          // Tens digit also rolls over: seconds = 00 and increment minutes
          ss <= 8'h00;

          // Increment minutes
          if (mm[3:0] == 4'd9) begin
            // Ones digit of minutes rolls over
            if (mm[7:4] == 4'd5) begin
              // Tens digit also rolls over: minutes = 00 and increment hours
              mm <= 8'h00;

              // Increment hours with 12-hour format and toggle pm when rolling over 12 -> 1
              if (hh == 8'h12) begin
                // From 12 to 1
                hh <= 8'h01;
                pm <= ~pm; // Toggle AM/PM
              end else if (hh[7:4] == 4'd0) begin
                // Tens = 0, ones digit 1-9
                if (hh[3:0] == 4'd9) begin
                  // From 09 to 10
                  hh <= 8'h10;
                end else begin
                  // Increment ones digit
                  hh <= {hh[7:4], hh[3:0] + 4'd1};
                end
              end else if (hh == 8'h10) begin
                // From 10 to 11
                hh <= 8'h11;
              end else if (hh == 8'h11) begin
                // From 11 to 12
                hh <= 8'h12;
              end else begin
                // Defensive fallback: just increment as BCD (should not happen)
                hh <= hh + 8'd1;
              end

            end else begin
              // Increment tens digit of minutes only
              mm <= {mm[7:4] + 4'd1, 4'd0};
            end
          end else begin
            // Increment ones digit of minutes only
            mm <= {mm[7:4], mm[3:0] + 4'd1};
          end

        end else begin
          // Increment tens digit of seconds only
          ss <= {ss[7:4] + 4'd1, 4'd0};
        end
      end else begin
        // Increment ones digit of seconds only
        ss <= {ss[7:4], ss[3:0] + 4'd1};
      end
    end
  end

endmodule