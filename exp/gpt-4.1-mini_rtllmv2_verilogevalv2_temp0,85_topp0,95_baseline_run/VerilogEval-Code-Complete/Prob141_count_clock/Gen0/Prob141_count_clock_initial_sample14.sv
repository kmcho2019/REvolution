module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Internal signals for BCD digits
  reg [3:0] ss_ones, ss_tens;
  reg [3:0] mm_ones, mm_tens;
  reg [3:0] hh_ones, hh_tens;

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      ss_ones <= 4'd0;
      ss_tens <= 4'd0;
      mm_ones <= 4'd0;
      mm_tens <= 4'd0;
      hh_ones <= 4'd2;  // "12" hours
      hh_tens <= 4'd1;
      pm <= 1'b0;       // AM
    end else if (ena) begin
      // Increment seconds
      if (ss_ones == 4'd9) begin
        ss_ones <= 4'd0;
        if (ss_tens == 4'd5) begin
          ss_tens <= 4'd0;
          // Increment minutes
          if (mm_ones == 4'd9) begin
            mm_ones <= 4'd0;
            if (mm_tens == 4'd5) begin
              mm_tens <= 4'd0;
              // Increment hours
              if ( (hh_tens == 4'd1 && hh_ones == 4'd2) ) begin
                // Going from 12 to 1, toggle pm
                hh_tens <= 4'd0;
                hh_ones <= 4'd1;
                pm <= ~pm;
              end else if (hh_ones == 4'd9) begin
                // If ones digit is 9, tens digit must be 0 or 1, but hours go only to 12
                // So this should not happen, but safe fallback:
                hh_ones <= 4'd0;
                hh_tens <= hh_tens + 4'd1;
              end else if (hh_tens == 4'd0 && hh_ones == 4'd9) begin
                // From 09 to 10
                hh_ones <= 4'd0;
                hh_tens <= 4'd1;
              end else begin
                // General increment hours
                // Need to handle 01-12 only
                // Increment ones digit:
                if (hh_tens == 4'd0) begin
                  if (hh_ones == 4'd9) begin
                    hh_ones <= 4'd0;
                    hh_tens <= 4'd1;
                  end else begin
                    hh_ones <= hh_ones + 4'd1;
                  end
                end else if (hh_tens == 4'd1) begin
                  // hours tens digit is 1, ones digit max 2
                  if (hh_ones == 4'd2) begin
                    // will be handled earlier, but fallback:
                    hh_ones <= 4'd1;
                  end else begin
                    hh_ones <= hh_ones + 4'd1;
                  end
                end
              end
            end else begin
              mm_tens <= mm_tens + 4'd1;
            end
          end else begin
            mm_ones <= mm_ones + 4'd1;
          end
        end else begin
          ss_tens <= ss_tens + 4'd1;
        end
      end else begin
        ss_ones <= ss_ones + 4'd1;
      end
    end
  end

  // Combine digits to outputs
  always @(*) begin
    hh = {hh_tens, hh_ones};
    mm = {mm_tens, mm_ones};
    ss = {ss_tens, ss_ones};
  end

endmodule