module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to increment BCD from 0x00 to 0x59
  // returns {carry, new_bcd}
  function automatic [8:0] bcd_inc_59;
    input [7:0] val;
    reg [3:0] units;
    reg [3:0] tens;
    begin
      units = val[3:0];
      tens = val[7:4];
      if (units == 4'd9) begin
        units = 4'd0;
        if (tens == 4'd5) begin
          tens = 4'd0;
          bcd_inc_59 = {1'b1, {tens, units}};
        end else begin
          tens = tens + 1;
          bcd_inc_59 = {1'b0, {tens, units}};
        end
      end else begin
        units = units + 1;
        bcd_inc_59 = {1'b0, {tens, units}};
      end
    end
  endfunction

  // Helper function to increment hours in BCD (01-12)
  // returns {carry, new_bcd}
  function automatic [8:0] bcd_inc_12;
    input [7:0] val;
    reg [3:0] units;
    reg [3:0] tens;
    reg [7:0] next;
    begin
      units = val[3:0];
      tens = val[7:4];

      // increment
      if (units == 4'd9) begin
        units = 4'd0;
        tens = tens + 1;
      end else begin
        units = units + 1;
      end
      next = {tens, units};

      // check overflow > 12 (0x12)
      if ((next > 8'h12) || (tens == 4'd0 && units == 4'd0)) begin
        // wrap to 1
        next = 8'h01;
        bcd_inc_12 = {1'b1, next};
      end else begin
        bcd_inc_12 = {1'b0, next};
      end
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // reset to 12:00:00 AM
      hh <= 8'h12; // 0x12 = 12 in BCD
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 1'b0;
    end else if (ena) begin
      // increment seconds
      reg [8:0] sec_inc;
      reg [8:0] min_inc;
      reg [8:0] hr_inc;

      sec_inc = bcd_inc_59(ss);
      ss <= sec_inc[7:0];

      if (sec_inc[8]) begin
        // seconds rolled over
        min_inc = bcd_inc_59(mm);
        mm <= min_inc[7:0];
        if (min_inc[8]) begin
          // minutes rolled over
          hr_inc = bcd_inc_12(hh);
          hh <= hr_inc[7:0];
          if (hr_inc[8]) begin
            // hours rolled over from 12 -> 1, toggle pm
            pm <= ~pm;
          end
        end
      end
    end
  end

endmodule