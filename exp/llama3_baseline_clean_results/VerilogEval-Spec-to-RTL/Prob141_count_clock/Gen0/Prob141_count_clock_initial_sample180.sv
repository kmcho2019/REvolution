module TopModule(
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
            // Reset the clock to 12:00 AM
            hh <= 8'b0001_0010; // 12 in BCD
            mm <= 8'b0000_0000; // 00 in BCD
            ss <= 8'b0000_0000; // 00 in BCD
            pm <= 1'b0; // AM
        end else if (ena) begin
            // Increment the seconds counter
            if (ss == 8'b0000_1001) begin // 59 in BCD
                ss <= 8'b0000_0000; // 00 in BCD
                // Increment the minutes counter
                if (mm == 8'b0000_1001) begin // 59 in BCD
                    mm <= 8'b0000_0000; // 00 in BCD
                    // Increment the hours counter
                    if (hh == 8'b0001_0010) begin // 12 in BCD
                        hh <= 8'b0001_0010; // 12 in BCD
                        pm <= ~pm; // Toggle AM/PM
                    end else if (hh == 8'b0000_1001) begin // 01 in BCD (1 PM)
                        hh <= 8'b0001_0010; // 12 in BCD
                        pm <= 1'b1; // PM
                    end else if (hh == 8'b0001_0100) begin // 12 in BCD (12 PM)
                        hh <= 8'b0000_0001; // 01 in BCD
                        pm <= 1'b1; // PM
                    end else begin
                        hh <= hh + 8'b0000_0001; // Increment hours
                    end
                end else begin
                    mm <= mm + 8'b0000_0001; // Increment minutes
                end
            end else begin
                ss <= ss + 8'b0000_0001; // Increment seconds
            end
        end
    end

endmodule