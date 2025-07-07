module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to increment BCD from 00 to 59 for mm and ss
  function [7:0] bcd_inc_59;
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
      bcd_inc_59 = {tens, ones};
    end
  endfunction

  // Helper function to check if BCD is 59
  function is_59;
    input [7:0] bcd_in;
    begin
      is_59 = (bcd_in == 8'h59);
    end
  endfunction

  // Helper function to increment hour in 12-hour BCD format (01 to 12)
  // Returns new hour and a flag indicating if hour rolled over from 12 to 1
  function [8:0] bcd_inc_12;
    input [7:0] bcd_in;
    reg [7:0] next_hh;
    reg rollover;
    reg [3:0] ones, tens;
    begin
      ones = bcd_in[3:0];
      tens = bcd_in[7:4];
      if (bcd_in == 8'h12) begin
        next_hh = 8'h01;
        rollover = 1'b1;
      end else if (ones == 4'd9) begin
        ones = 4'd0;
        tens = tens + 4'd1;
        next_hh = {tens, ones};
        rollover = 1'b0;
      end else begin
        ones = ones + 4'd1;
        next_hh = {tens, ones};
        rollover = 1'b0;
      end
      bcd_inc_12 = {rollover, next_hh};
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
      if (is_59(ss)) begin
        ss <= 8'h00;
        if (is_59(mm)) begin
          mm <= 8'h00;
          // Increment hour
          // bcd_inc_12 returns {rollover, new_hour}
          // rollover toggles pm
          reg rollover;
          reg [7:0] new_hh;
          {rollover, new_hh} = bcd_inc_12(hh);
          hh <= new_hh;
          if (rollover)
            pm <= ~pm;
        end else begin
          mm <= bcd_inc_59(mm);
        end
      end else begin
        ss <= bcd_inc_59(ss);
      end
    end
  end

endmodule