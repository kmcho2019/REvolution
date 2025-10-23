module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            // Reset all counters and pm indicator on reset
            hh <= 8'b0001_0010;  // 12 in BCD
            mm <= 8'b0000_0000;  // 00 in BCD
            ss <= 8'b0000_0000;  // 00 in BCD
            pm <= 1'b0;          // Set to AM
        end else if (ena) begin
            // Increment seconds counter
            if (ss == 8'b0101_0111) begin  // 59 in BCD
                ss <= 8'b0000_0000;  // Reset to 00
                // Increment minutes counter
                if (mm == 8'b0101_0111) begin  // 59 in BCD
                    mm <= 8'b0000_0000;  // Reset to 00
                    // Increment hours counter
                    if (hh == 8'b0001_0010) begin  // 12 in BCD
                        hh <= 8'b0001_0010;  // Stay at 12 for AM
                        pm <= 1'b1;          // Switch to PM
                    end else if (hh == 8'b0000_0101) begin  // 1 in BCD for PM
                        hh <= 8'b0001_0010;  // 12 for PM
                    end else begin
                        // Increment hours normally
                        hh <= hh + 1;
                        pm <= (hh[3:0] > 4'd9) ? 1'b1 : 1'b0;  // Determine AM/PM based on hours
                    end
                end else begin
                    mm <= mm + 1;
                end
            end else begin
                ss <= ss + 1;
            end
        end
    end

endmodule