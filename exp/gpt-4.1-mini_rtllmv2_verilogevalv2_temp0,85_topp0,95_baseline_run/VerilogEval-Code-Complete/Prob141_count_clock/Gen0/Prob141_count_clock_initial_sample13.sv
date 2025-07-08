module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Internal helper functions
  // BCD increment with rollover for 00-59 counting (minutes, seconds)
  function [7:0] bcd_inc_59;
    input [7:0] bcd_in;
    reg [3:0] ones, tens;
    begin
      ones = bcd_in[3:0];
      tens = bcd_in[7:4];
      if (ones == 4'd9) begin
        ones = 4'd0;
        if (tens == 4'd5) begin
          tens = 4'd0;
        end else begin
          tens = tens + 4'd1;
        end
      end else begin
        ones = ones + 4'd1;
      end
      bcd_inc_59 = {tens, ones};
    end
  endfunction

  // Check if BCD is 59
  function is_59;
    input [7:0] bcd_in;
    begin
      is_59 = (bcd_in == 8'h59);
    end
  endfunction

  // Hours increment for 12-hour format (01-12)
  // Returns updated hour BCD and flag indicating if hour rolled over from 12 to 01
  function [8:0] hour_inc; // [8] rollover flag, [7:0] updated hour
    input [7:0] bcd_in;
    reg [3:0] ones, tens;
    reg [7:0] result;
    reg rollover;
    begin
      ones = bcd_in[3:0];
      tens = bcd_in[7:4];
      rollover = 0;
      // Increment hour BCD
      if (bcd_in == 8'h12) begin
        // roll over from 12 to 01
        result = 8'h01;
        rollover = 1;
      end else if (ones == 4'd9) begin
        // ones digit rolls over from 9 to 0, tens increments
        ones = 4'd0;
        if (tens == 4'd0) begin
          tens = 4'd1;
        end else begin
          // This case normally won't occur in 12-hour BCD, but safe to cover
          tens = 4'd0;
        end
        result = {tens, ones};
      end else begin
        // normal increment
        ones = ones + 4'd1;
        result = {tens, ones};
      end

      hour_inc = {rollover, result};
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // reset to 12:00:00 AM
      hh <= 8'h12;  // 0x12 = BCD 12
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
          // hour_inc returns {rollover_flag, new_hour}
          // unpack it
          reg [8:0] hour_inc_res;
          hour_inc_res = hour_inc(hh);
          hh <= hour_inc_res[7:0];
          if (hour_inc_res[8]) begin
            pm <= ~pm;  // toggle pm when hour rolls over 12 -> 01
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