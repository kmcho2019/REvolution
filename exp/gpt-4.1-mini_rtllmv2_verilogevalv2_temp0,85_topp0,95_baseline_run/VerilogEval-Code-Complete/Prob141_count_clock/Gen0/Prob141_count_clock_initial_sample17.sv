module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // BCD increment function for a two-digit BCD number (0x00 to 0x59)
  function [7:0] bcd_increment_59;
    input [7:0] bcd_in;
    reg [3:0] ones, tens;
    begin
      ones = bcd_in[3:0];
      tens = bcd_in[7:4];
      if (ones == 4'd9) begin
        ones = 4'd0;
        if (tens == 4'd5)
          tens = 4'd0;
        else
          tens = tens + 4'd1;
      end else begin
        ones = ones + 4'd1;
      end
      bcd_increment_59 = {tens, ones};
    end
  endfunction

  // Check if bcd is 59
  function is_59;
    input [7:0] bcd_in;
    begin
      is_59 = (bcd_in == 8'h59);
    end
  endfunction

  // BCD increment for hours 01 to 12
  // Returns incremented hour and a carry-out indicating hour wrapped from 12 to 1
  function [8:0] bcd_increment_hour; // 9 bits: 8 for hour, 1 for carry out
    input [7:0] hour_in;
    reg [3:0] ones, tens;
    reg [7:0] next_hour;
    reg carry_out;
    begin
      ones = hour_in[3:0];
      tens = hour_in[7:4];
      // Increment hour in BCD
      if (hour_in == 8'h12) begin
        next_hour = 8'h01;
        carry_out = 1'b1;
      end else if (ones == 4'd9) begin
        ones = 4'd0;
        tens = tens + 4'd1;
        next_hour = {tens, ones};
        carry_out = 1'b0;
      end else begin
        ones = ones + 4'd1;
        next_hour = {tens, ones};
        carry_out = 1'b0;
      end
      bcd_increment_hour = {carry_out, next_hour};
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
      // Increment seconds
      if (is_59(ss)) begin
        ss <= 8'h00;
        // Increment minutes
        if (is_59(mm)) begin
          mm <= 8'h00;
          // Increment hours
          // Use function to increment hour and get carry for toggling pm
          reg [8:0] inc_hour;
          inc_hour = bcd_increment_hour(hh);
          hh <= inc_hour[7:0];
          if (inc_hour[8]) begin
            // Hour rolled over from 12 to 1, toggle pm
            pm <= ~pm;
          end
        end else begin
          mm <= bcd_increment_59(mm);
        end
      end else begin
        ss <= bcd_increment_59(ss);
      end
    end
  end

endmodule