module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // BCD helper functions
  function [7:0] bcd_increment_0to9(input [7:0] bcd);
    reg [3:0] ones;
    reg [3:0] tens;
  begin
    tens = bcd[7:4];
    ones = bcd[3:0];
    if (ones == 4'd9) begin
      ones = 4'd0;
      tens = tens + 4'd1;
    end else begin
      ones = ones + 4'd1;
    end
    bcd_increment_0to9 = {tens, ones};
  end
  endfunction

  // Increment seconds BCD (00 to 59)
  function [7:0] sec_bcd_inc(input [7:0] bcd);
    reg [3:0] ones;
    reg [3:0] tens;
  begin
    tens = bcd[7:4];
    ones = bcd[3:0];
    if (tens == 4'd5 && ones == 4'd9) begin
      // roll over
      sec_bcd_inc = 8'h00;
    end else if (ones == 4'd9) begin
      ones = 4'd0;
      tens = tens + 4'd1;
      sec_bcd_inc = {tens, ones};
    end else begin
      ones = ones + 4'd1;
      sec_bcd_inc = {tens, ones};
    end
  end
  endfunction

  // Increment minutes BCD (00 to 59)
  function [7:0] min_bcd_inc(input [7:0] bcd);
    reg [3:0] ones;
    reg [3:0] tens;
  begin
    tens = bcd[7:4];
    ones = bcd[3:0];
    if (tens == 4'd5 && ones == 4'd9) begin
      // roll over
      min_bcd_inc = 8'h00;
    end else if (ones == 4'd9) begin
      ones = 4'd0;
      tens = tens + 4'd1;
      min_bcd_inc = {tens, ones};
    end else begin
      ones = ones + 4'd1;
      min_bcd_inc = {tens, ones};
    end
  end
  endfunction

  // Increment hours BCD (01 to 12)
  function [7:0] hour_bcd_inc(input [7:0] bcd);
    reg [3:0] ones;
    reg [3:0] tens;
  begin
    tens = bcd[7:4];
    ones = bcd[3:0];
    // Hours range: 01 to 12 BCD
    // Next hour logic:
    // 01 to 08 normal increment
    // 09 -> 10
    // 10 -> 11
    // 11 -> 12
    // 12 -> 01
    if (bcd == 8'h12) begin
      hour_bcd_inc = 8'h01;
    end else if (bcd == 8'h09) begin
      hour_bcd_inc = 8'h10;
    end else begin
      if (ones == 4'd9) begin
        // Should only happen for 09 handled above, but for safety:
        ones = 4'd0;
        tens = tens + 4'd1;
      end else begin
        ones = ones + 4'd1;
      end
      hour_bcd_inc = {tens, ones};
    end
  end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      hh <= 8'h12;
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 1'b0;
    end else if (ena) begin
      if (ss == 8'h59) begin
        ss <= 8'h00;
        if (mm == 8'h59) begin
          mm <= 8'h00;
          if (hh == 8'h11) begin
            // 11 -> 12, toggle pm
            hh <= 8'h12;
            pm <= ~pm;
          end else if (hh == 8'h12) begin
            // 12 -> 01
            hh <= 8'h01;
          end else begin
            hh <= hour_bcd_inc(hh);
          end
        end else begin
          mm <= min_bcd_inc(mm);
        end
      end else begin
        ss <= sec_bcd_inc(ss);
      end
    end
  end

endmodule