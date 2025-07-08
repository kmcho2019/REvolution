module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // BCD increment function for 2-digit BCD (00-59)
  function [7:0] bcd_inc_59;
    input [7:0] val;
    reg [3:0] d1, d0;
    begin
      d1 = val[7:4];
      d0 = val[3:0];
      if (d0 == 4'd9) begin
        d0 = 4'd0;
        if (d1 == 4'd5)
          d1 = 4'd0;
        else
          d1 = d1 + 1;
      end else begin
        d0 = d0 + 1;
      end
      bcd_inc_59 = {d1, d0};
    end
  endfunction

  // Check if BCD value == 59
  function is_59;
    input [7:0] val;
    begin
      is_59 = (val[7:4] == 4'd5) && (val[3:0] == 4'd9);
    end
  endfunction

  // Check if hh is 12 in BCD
  function is_12;
    input [7:0] val;
    begin
      is_12 = (val == 8'h12);
    end
  endfunction

  // Check if hh is 11 in BCD
  function is_11;
    input [7:0] val;
    begin
      is_11 = (val == 8'h11);
    end
  endfunction

  // Check if hh is 01 in BCD
  function is_01;
    input [7:0] val;
    begin
      is_01 = (val == 8'h01);
    end
  endfunction

  // BCD increment for hour, 1-12 cycle
  function [7:0] bcd_inc_hour;
    input [7:0] val;
    begin
      // increment hour BCD with wrap 12->1
      if (is_12(val))
        bcd_inc_hour = 8'h01;
      else if ((val[3:0] == 4'd9)) begin
        // if ones digit is 9, tens digit increments
        // but since max is 12, and minimum 01, this only happens for 09->10
        // so handle 09->10 transition
        if (val == 8'h09)
          bcd_inc_hour = 8'h10;
        else
          bcd_inc_hour = val + 1; // normal increment
      end else begin
        bcd_inc_hour = val + 1;
      end
    end
  endfunction

  // Detect if hour is 11 - needed to toggle pm on hour increment from 11->12
  // We'll toggle pm when incrementing from 11 to 12

  always @(posedge clk) begin
    if (reset) begin
      // reset to 12:00:00 AM
      hh <= 8'h12;
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 1'b0;
    end else if (ena) begin
      // increment seconds
      if (is_59(ss)) begin
        ss <= 8'h00;
        // increment minutes
        if (is_59(mm)) begin
          mm <= 8'h00;
          // increment hours
          if (is_12(hh)) begin
            hh <= 8'h01;
            pm <= ~pm; // toggle am/pm when hour rolls over from 12 to 1
          end else if (is_11(hh)) begin
            // increment from 11 to 12 toggles pm
            hh <= 8'h12;
            pm <= ~pm;
          end else begin
            hh <= bcd_inc_hour(hh);
          end
        end else begin
          mm <= bcd_inc_59(mm);
        end
      end else begin
        ss <= bcd_inc_59(ss);
      end
    end
  end
endmodule