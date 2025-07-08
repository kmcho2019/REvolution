module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // BCD max values for each digit
  localparam MAX_SEC_MIN_UNITS = 4'd9;
  localparam MAX_SEC_MIN_TENS = 4'd5;
  localparam MAX_HH_UNITS_12 = 4'd2; // special logic for hours tens digit
  localparam MAX_HH_UNITS_1 = 4'd9; // for hours units digit general
  localparam MAX_HH_TENS_1 = 4'd1; // hours tens digit 0 or 1
  
  // Internal signals for BCD digits
  reg [3:0] ss_units, ss_tens;
  reg [3:0] mm_units, mm_tens;
  reg [3:0] hh_units, hh_tens;
  
  // Initialize/reset logic
  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh_tens <= 4'd1;
      hh_units <= 4'd2;
      mm_tens <= 4'd0;
      mm_units <= 4'd0;
      ss_tens <= 4'd0;
      ss_units <= 4'd0;
      pm <= 1'b0; // AM
    end else if (ena) begin
      // Increment seconds BCD
      if (ss_units < 4'd9) begin
        ss_units <= ss_units + 1;
      end else begin
        ss_units <= 4'd0;
        if (ss_tens < 4'd5) begin
          ss_tens <= ss_tens + 1;
        end else begin
          // Seconds rollover to 00, increment minutes
          ss_tens <= 4'd0;
          // Increment minutes BCD
          if (mm_units < 4'd9) begin
            mm_units <= mm_units + 1;
          end else begin
            mm_units <= 4'd0;
            if (mm_tens < 4'd5) begin
              mm_tens <= mm_tens + 1;
            end else begin
              // Minutes rollover to 00, increment hours
              mm_tens <= 4'd0;
              
              // Increment hours BCD in 12-hour format
              if ( (hh_tens == 4'd1 && hh_units == 4'd2) ) begin
                // If time is 12, roll over to 01 and toggle pm
                hh_tens <= 4'd0;
                hh_units <= 4'd1;
                pm <= ~pm;
              end else if (hh_units < 4'd9) begin
                hh_units <= hh_units + 1;
              end else begin
                // units digit = 9, roll to next tens digit
                hh_units <= 4'd0;
                hh_tens <= hh_tens + 1;
              end
              
              // After this logic, the hour count is correctly maintained between 01 to 12
              // Since 10, 11 handled by tens=1 and units=0/1
              // 09->10 increments tens digit properly
            end
          end
        end
      end
    end
  end
  
  // Concatenate outputs from internal BCD digits
  always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
  end

endmodule