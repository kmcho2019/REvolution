module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Function to increment a BCD digit with rollover to 0 after 9
  function [3:0] bcd_incr;
    input [3:0] digit;
    begin
      if (digit == 4'd9)
        bcd_incr = 4'd0;
      else
        bcd_incr = digit + 4'd1;
    end
  endfunction

  // Check if BCD digit represents 9
  function is_9;
    input [3:0] digit;
    begin
      is_9 = (digit == 4'd9);
    end
  endfunction

  // Check if BCD digit represents 5
  function is_5;
    input [3:0] digit;
    begin
      is_5 = (digit == 4'd5);
    end
  endfunction

  // Convert BCD hour to integer (1 to 12)
  function [4:0] bcd_hour_to_int;
    input [7:0] bcd_hour;
    begin
      bcd_hour_to_int = bcd_hour[7:4]*10 + bcd_hour[3:0];
    end
  endfunction

  // Convert integer (1 to 12) to BCD hour
  function [7:0] int_to_bcd_hour;
    input [4:0] val;
    begin
      int_to_bcd_hour = { (val / 10), (val % 10) };
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh <= 8'b0001_0010; // 12 in BCD
      mm <= 8'b0000_0000; // 00
      ss <= 8'b0000_0000; // 00
      pm <= 1'b0;         // AM
    end else if (ena) begin
      // Increment seconds
      if (ss[3:0] == 4'd9) begin
        // units digit of seconds rollover
        ss[3:0] <= 4'd0;
        if (ss[7:4] == 4'd5) begin
          // tens digit of seconds rollover (59 -> 00)
          ss[7:4] <= 4'd0;

          // Increment minutes
          if (mm[3:0] == 4'd9) begin
            mm[3:0] <= 4'd0;
            if (mm[7:4] == 4'd5) begin
              mm[7:4] <= 4'd0;

              // Increment hours (BCD 01 to 12)
              // Convert BCD hour to integer
              // because hours count 1 to 12
              // We will do manual BCD increment for hours here

              // Extract digits
              reg [3:0] h_tens = hh[7:4];
              reg [3:0] h_units = hh[3:0];
              reg [4:0] h_int;

              h_int = h_tens * 10 + h_units;

              if (h_int == 12) begin
                // Roll over to 1 and toggle pm
                hh <= 8'b0000_0001; // 01 BCD
                pm <= ~pm;
              end else begin
                // Increment hour by 1
                h_int = h_int + 1;
                hh <= { (h_int / 10), (h_int % 10) };
              end

            end else begin
              mm[7:4] <= mm[7:4] + 4'd1;
            end
          end else begin
            mm[3:0] <= mm[3:0] + 4'd1;
          end

        end else begin
          ss[7:4] <= ss[7:4] + 4'd1;
        end

      end else begin
        ss[3:0] <= ss[3:0] + 4'd1;
      end
    end
  end

endmodule