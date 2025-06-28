module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

reg [3:0] hh_t, mm_t, ss_t; // Temporary BCD counters

always @ (posedge clk) begin
  if (reset) begin
    hh <= 4'b0001; // Initialize hours to 1 (1 in BCD)
    mm <= 6'b000000; // Initialize minutes to 00 (00 in BCD)
    ss <= 6'b000000; // Initialize seconds to 00 (00 in BCD)
    pm <= 1'b0; // Initialize to AM
  end
  else if (ena) begin
    ss_t <= (ss == 6'b010110) ? 6'b000000 : ss + 1; // Increment seconds, reset if 59
    if (ss == 6'b010110) begin // If seconds go from 59 to 00
      mm_t <= (mm == 6'b010110) ? mm + 1 : 6'b000000; // Increment minutes if necessary
      if (mm == 6'b010110) begin // If minutes go from 59 to 00
        hh_t <= (hh == 4'b000110) ? hh + 1 : (hh == 4'b000101) ? 4'b0001 : 4'b0000; // Increment hours if necessary
        if (hh == 4'b000110) begin // Toggle pm if hours go from 12 to 1
          pm <= ~pm;
        end
      end
    end
    hh <= hh_t;
    mm <= mm_t;
    ss <= ss_t;
  end
end

endmodule