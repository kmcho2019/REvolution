module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to increment a BCD digit (0-9) with rollover to 0
  function [3:0] bcd_inc;
    input [3:0] digit;
    begin
      if (digit == 4'd9)
        bcd_inc = 4'd0;
      else
        bcd_inc = digit + 4'd1;
    end
  endfunction

  // Helper function to compare two BCD digits
  function bcd_eq;
    input [3:0] a, b;
    begin
      bcd_eq = (a == b);
    end
  endfunction

  // Registers for each digit
  reg [3:0] ss_units, ss_tens;
  reg [3:0] mm_units, mm_tens;
  reg [3:0] hh_units, hh_tens;

  // Internal signals for carry detection
  wire ss_rollover, mm_rollover, hh_rollover;

  // Seconds increment logic
  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      ss_units <= 4'd0;
      ss_tens <= 4'd0;
      mm_units <= 4'd0;
      mm_tens <= 4'd0;
      hh_units <= 4'd2;
      hh_tens <= 4'd1;
      pm <= 1'b0;
    end else if (ena) begin
      // Increment seconds
      if (ss_units == 4'd9) begin
        ss_units <= 4'd0;
        if (ss_tens == 4'd5) begin
          ss_tens <= 4'd0;
          // Increment minutes
          if (mm_units == 4'd9) begin
            mm_units <= 4'd0;
            if (mm_tens == 4'd5) begin
              mm_tens <= 4'd0;
              // Increment hours
              // Handle hour increments with 12-hour format
              if (hh_tens == 4'd0 && hh_units == 4'd9) begin
                // 09 to 10
                hh_tens <= 4'd1;
                hh_units <= 4'd0;
              end else if (hh_tens == 4'd1 && hh_units == 4'd1) begin
                // 11 to 12
                hh_tens <= 4'd1;
                hh_units <= 4'd2;
                // Toggle pm at 12
                pm <= ~pm;
              end else if (hh_tens == 4'd1 && hh_units == 4'd2) begin
                // 12 to 01
                hh_tens <= 4'd0;
                hh_units <= 4'd1;
              end else begin
                // Normal increment for 01 to 08
                if (hh_units == 4'd9) begin
                  hh_tens <= hh_tens + 4'd1;
                  hh_units <= 4'd0;
                end else begin
                  hh_units <= hh_units + 4'd1;
                end
              end
            end else begin
              mm_tens <= mm_tens + 4'd1;
            end
          end else begin
            mm_units <= mm_units + 4'd1;
          end
        end else begin
          ss_tens <= ss_tens + 4'd1;
        end
      end else begin
        ss_units <= ss_units + 4'd1;
      end
    end
  end

  // Output assignments
  always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
  end

endmodule