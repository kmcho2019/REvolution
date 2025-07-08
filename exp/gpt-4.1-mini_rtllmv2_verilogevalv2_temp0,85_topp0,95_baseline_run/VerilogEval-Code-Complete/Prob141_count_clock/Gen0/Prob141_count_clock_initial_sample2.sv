module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

  // Helper function to check if BCD digit >= 9 (to validate correct BCD)
  // Not strictly needed as we control all increments, but can be used if desired.

  // Extract digits for clarity
  wire [3:0] ss_ones = ss[3:0];
  wire [3:0] ss_tens = ss[7:4];
  wire [3:0] mm_ones = mm[3:0];
  wire [3:0] mm_tens = mm[7:4];
  wire [3:0] hh_ones = hh[3:0];
  wire [3:0] hh_tens = hh[7:4];

  always @(posedge clk) begin
    if (reset) begin
      // Reset to 12:00:00 AM
      pm <= 0;
      hh <= 8'h12; // '1' = 0x1, '2' = 0x2: 0x12
      mm <= 8'h00;
      ss <= 8'h00;
    end else if (ena) begin
      // Increment seconds
      if (ss_ones < 4'd9) begin
        ss[3:0] <= ss_ones + 1;
      end else begin
        // ss_ones == 9, roll over ones digit and increment tens
        ss[3:0] <= 4'd0;
        if (ss_tens < 4'd5) begin
          ss[7:4] <= ss_tens + 1;
        end else begin
          // seconds roll over from 59 to 00, reset seconds and increment minutes
          ss <= 8'h00;

          // Increment minutes
          if (mm_ones < 4'd9) begin
            mm[3:0] <= mm_ones + 1;
          end else begin
            // mm_ones == 9, roll over ones digit and increment tens
            mm[3:0] <= 4'd0;
            if (mm_tens < 4'd5) begin
              mm[7:4] <= mm_tens + 1;
            end else begin
              // minutes roll over from 59 to 00, reset minutes and increment hours
              mm <= 8'h00;

              // Increment hours from 1 to 12
              // Convert BCD hour to integer for easier logic:
              // hour = hh_tens*10 + hh_ones
              // Then increment hour and handle overflow and pm toggle
              integer hour;
              hour = hh_tens * 10 + hh_ones;

              if (hour == 12) begin
                hour = 1;
                // Toggle PM at rollover from 12 to 1
                pm <= ~pm;
              end else begin
                hour = hour + 1;
              end
              // Update hh with new hour in BCD
              hh[7:4] <= hour / 10;
              hh[3:0] <= hour % 10;
            end
          end
        end
      end
    end
  end

endmodule