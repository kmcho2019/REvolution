module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00 AM
            hh <= 8'b0001_0010; // 12 in BCD
            mm <= 8'b0000_0000; // 00 in BCD
            ss <= 8'b0000_0000; // 00 in BCD
            pm <= 1'b0; // AM
        end else if (ena) begin
            // Increment seconds counter
            if (ss == 8'b0101_1001) begin // 59 in BCD
                ss <= 8'b0000_0000; // 00 in BCD
                // Increment minutes counter
                if (mm == 8'b0101_1001) begin // 59 in BCD
                    mm <= 8'b0000_0000; // 00 in BCD
                    // Increment hours counter
                    if (hh == 8'b0001_0010) begin // 12 in BCD
                        hh <= 8'b0001_0001; // 1 in BCD
                        pm <= ~pm; // Toggle AM/PM
                    end else if (hh == 8'b0000_1000) begin // 12 in BCD for PM
                        hh <= 8'b0001_0001; // 1 in BCD
                        pm <= ~pm; // Toggle AM/PM
                    end else begin
                        // Increment hours counter
                        if (hh[3:0] == 4'd9) begin
                            hh[3:0] <= 4'd0;
                            if (hh[7:4] == 4'd1) begin
                                hh[7:4] <= 4'd0;
                            end else begin
                                hh[7:4] <= hh[7:4] + 1;
                            end
                        end else begin
                            hh[3:0] <= hh[3:0] + 1;
                        end
                    end
                end else if (mm[3:0] == 4'd9) begin
                    mm[3:0] <= 4'd0;
                    if (mm[7:4] == 4'd5) begin
                        mm[7:4] <= 4'd0;
                    end else begin
                        mm[7:4] <= mm[7:4] + 1;
                    end
                end else begin
                    mm[3:0] <= mm[3:0] + 1;
                end
            end else begin
                ss[3:0] <= ss[3:0] + 1;
                if (ss[3:0] == 4'd0 && ss[7:4] != 4'd5) begin
                    ss[7:4] <= ss[7:4] + 1;
                end
            end
        end
    end

endmodule