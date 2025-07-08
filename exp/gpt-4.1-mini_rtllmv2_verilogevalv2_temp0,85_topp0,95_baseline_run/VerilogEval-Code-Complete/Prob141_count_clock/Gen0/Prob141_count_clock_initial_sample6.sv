module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function: increment BCD value with max limit
  function [7:0] bcd_increment(
    input [7:0] val,
    input [7:0] max_val
  );
    reg [7:0] next_val;
    begin
      // Increment ones digit
      if (val[3:0] == 4'd9) begin
        next_val[3:0] = 4'd0;
        // Increment tens digit
        if (val[7:4] == 4'd9)
          next_val[7:4] = 4'd0;
        else
          next_val[7:4] = val[7:4] + 4'd1;
      end else begin
        next_val[7:4] = val[7:4];
        next_val[3:0] = val[3:0] + 4'd1;
      end
      
      // If next_val exceeds max_val, roll over to 0
      if (next_val > max_val)
        bcd_increment = 8'd0;
      else
        bcd_increment = next_val;
    end
  endfunction

  // Compare BCD values for equality
  function is_bcd_equal(
    input [7:0] a,
    input [7:0] b
  );
    begin
      is_bcd_equal = (a == b);
    end
  endfunction

  // Constants
  localparam [7:0] HH_12 = 8'h12; // 12 in BCD
  localparam [7:0] HH_11 = 8'h11; // 11 in BCD
  localparam [7:0] HH_01 = 8'h01; // 01 in BCD
  localparam [7:0] MM_SS_MAX = 8'h59; // 59 in BCD
  localparam [7:0] ZERO = 8'h00;

  always @(posedge clk) begin
    if (reset) begin
      // Reset time to 12:00:00 AM
      hh <= HH_12;
      mm <= ZERO;
      ss <= ZERO;
      pm <= 1'b0;
    end else if (ena) begin
      // Increment seconds
      if (is_bcd_equal(ss, MM_SS_MAX)) begin
        ss <= ZERO;

        // Increment minutes
        if (is_bcd_equal(mm, MM_SS_MAX)) begin
          mm <= ZERO;

          // Increment hours
          if (is_bcd_equal(hh, HH_12)) begin
            hh <= HH_01;
            pm <= ~pm; // Toggle AM/PM on hour rollover from 12 to 1
          end else begin
            // Increment hours in BCD, careful with 12-hour counting
            // bcd_increment returns 0 if passes max, so limit max is 12
            // Hours valid range: 1 to 12 (01 to 12 in BCD)
            // If hh < 12, increment normally
            // But since bcd_increment returns 0 on overflow, handle that below
            // We can safely use bcd_increment with max 12

            // Compute next hour
            // bcd_increment may return 0, so check and fix if needed
            reg [7:0] next_hh;
            next_hh = bcd_increment(hh, HH_12);
            if (next_hh == 8'h00)
              hh <= HH_01;
            else
              hh <= next_hh;
          end

        end else begin
          mm <= bcd_increment(mm, MM_SS_MAX);
        end

      end else begin
        ss <= bcd_increment(ss, MM_SS_MAX);
      end
    end
  end

endmodule