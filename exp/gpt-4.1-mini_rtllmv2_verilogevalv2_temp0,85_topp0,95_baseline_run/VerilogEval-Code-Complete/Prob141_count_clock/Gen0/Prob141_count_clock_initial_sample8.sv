module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Extract BCD digits helpers
  wire [3:0] ss_ones = ss[3:0];
  wire [3:0] ss_tens = ss[7:4];
  wire [3:0] mm_ones = mm[3:0];
  wire [3:0] mm_tens = mm[7:4];
  wire [3:0] hh_ones = hh[3:0];
  wire [3:0] hh_tens = hh[7:4];

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      ss <= 8'h00;
      mm <= 8'h00;
      hh <= 8'h12;
      pm <= 1'b0;
    end else if (ena) begin
      // Increment seconds
      if (ss_ones == 4'd9) begin
        if (ss_tens == 4'd5) begin
          // seconds rollover 59 -> 00
          ss <= 8'h00;

          // increment minutes
          if (mm_ones == 4'd9) begin
            if (mm_tens == 4'd5) begin
              // minutes rollover 59 -> 00
              mm <= 8'h00;

              // increment hours
              // hours range: 01 to 12
              if (hh == 8'h11) begin
                // hour 11 -> 12, toggle pm
                hh <= 8'h12;
                pm <= ~pm;
              end else if (hh == 8'h12) begin
                // hour 12 -> 01
                hh <= 8'h01;
              end else begin
                // increment hour BCD
                if (hh_ones == 4'd9) begin
                  hh <= {hh_tens + 4'd1, 4'd0};
                end else begin
                  hh <= {hh_tens, hh_ones + 4'd1};
                end
              end

            end else begin
              // increment minutes tens digit
              mm <= {mm_tens + 4'd1, 4'd0};
            end
          end else begin
            // increment minutes ones digit
            mm <= {mm_tens, mm_ones + 4'd1};
          end

        end else begin
          // increment seconds tens digit
          ss <= {ss_tens + 4'd1, 4'd0};
        end
      end else begin
        // increment seconds ones digit
        ss <= {ss_tens, ss_ones + 4'd1};
      end
    end
  end

endmodule