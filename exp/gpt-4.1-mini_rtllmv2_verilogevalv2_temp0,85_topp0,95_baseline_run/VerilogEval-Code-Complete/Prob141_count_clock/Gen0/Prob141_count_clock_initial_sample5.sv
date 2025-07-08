module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Function to increment a BCD digit (4 bits) from 0 to 9, rolling over to 0
  function [3:0] bcd_inc(input [3:0] bcd_digit);
    begin
      if (bcd_digit == 4'd9)
        bcd_inc = 4'd0;
      else
        bcd_inc = bcd_digit + 4'd1;
    end
  endfunction

  // Check if BCD digit is 9 (max digit)
  function bcd_is_9(input [3:0] bcd_digit);
    begin
      bcd_is_9 = (bcd_digit == 4'd9);
    end
  endfunction

  // Check if two BCD digits equal 59
  function time_is_59(input [7:0] bcd_val);
    begin
      time_is_59 = ((bcd_val[7:4] == 4'd5) && (bcd_val[3:0] == 4'd9));
    end
  endfunction

  // Check if two BCD digits equal 11 (for hour rollover detection)
  function time_is_11(input [7:0] bcd_val);
    begin
      time_is_11 = ((bcd_val[7:4] == 4'd1) && (bcd_val[3:0] == 4'd1));
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh <= 8'h12; // 0x12 = 0b0001_0010 = 12 in BCD
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 1'b0;
    end else if (ena) begin
      // Increment seconds
      if (time_is_59(ss)) begin
        ss <= 8'h00;
        // Increment minutes
        if (time_is_59(mm)) begin
          mm <= 8'h00;
          // Increment hours
          // Hours count from 01 to 12
          // Extract digits
          reg [3:0] h_tens, h_ones;
          h_tens = hh[7:4];
          h_ones = hh[3:0];

          // Increment hour BCD
          // We'll manually handle 12-hour counting:
          // If hour == 12, next hour is 1
          if (hh == 8'h12) begin
            hh <= 8'h01;
            // Toggle pm at rollover from 11 to 12, so toggle pm when hour changes from 12 to 1
            pm <= ~pm;
          end else begin
            // Increment hour BCD
            if (bcd_is_9(h_ones)) begin
              h_ones = 4'd0;
              if (h_tens == 4'd1) begin
                // max hour is 12, so if tens=1 and ones=2, will be handled by above
                // so if tens=1 and ones=9 (invalid), reset to 10
                // But as we only go to 12, tens can be 0 or 1 only
                h_tens = 4'd1;
                // But normally tens won't increment beyond 1 for hours
                // This case won't happen if input is valid
              end else begin
                h_tens = h_tens + 4'd1;
              end
            end else begin
              h_ones = h_ones + 4'd1;
            end
            hh <= {h_tens, h_ones};

            // Toggle pm when hour increments from 11 to 12
            if (time_is_11(hh)) begin
              // Next hour will be 12, toggle pm
              pm <= ~pm;
            end
          end
        end else begin
          // Increment minutes BCD
          reg [3:0] m_tens, m_ones;
          m_tens = mm[7:4];
          m_ones = mm[3:0];
          if (bcd_is_9(m_ones)) begin
            m_ones = 4'd0;
            m_tens = m_tens + 4'd1;
          end else begin
            m_ones = m_ones + 4'd1;
          end
          mm <= {m_tens, m_ones};
        end
      end else begin
        // Increment seconds BCD
        reg [3:0] s_tens, s_ones;
        s_tens = ss[7:4];
        s_ones = ss[3:0];
        if (bcd_is_9(s_ones)) begin
          s_ones = 4'd0;
          s_tens = s_tens + 4'd1;
        end else begin
          s_ones = s_ones + 4'd1;
        end
        ss <= {s_tens, s_ones};
      end
    end
  end

endmodule