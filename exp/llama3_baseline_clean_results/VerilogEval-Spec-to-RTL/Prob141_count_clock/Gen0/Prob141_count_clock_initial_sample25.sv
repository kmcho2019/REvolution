module TopModule (
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
        // Reset the clock to "12:00 AM"
        hh <= 8'b00010010; // 12 in BCD
        mm <= 8'b00000000; // 00 in BCD
        ss <= 8'b00000000; // 00 in BCD
        pm <= 1'b0; // AM
    end else if (ena) begin
        // Increment the seconds counter
        if (ss == 8'b00000000 + 59) begin
            ss <= 8'b00000000; // Reset seconds to 00
            // Increment the minutes counter
            if (mm == 8'b00000000 + 59) begin
                mm <= 8'b00000000; // Reset minutes to 00
                // Increment the hours counter
                if (hh == 8'b00010010 + 12) begin // 12 in BCD + 12 (12:00 PM to 12:00 AM)
                    hh <= 8'b00010010; // Reset hours to 12
                    pm <= 1'b0; // Reset to AM
                end else if (hh == 8'b00010010) begin // 12 in BCD (12:00 AM to 01:00 AM)
                    hh <= 8'b00010001; // Increment hours to 01
                    pm <= 1'b0; // Stay in AM
                end else if (hh == 8'b00010100) begin // 12 in BCD + 1 (01:00 AM to 12:00 PM)
                    hh <= 8'b00010010; // Increment hours to 12
                    pm <= 1'b1; // Switch to PM
                end else begin
                    // Increment hours (01-11)
                    hh <= hh + 1;
                    // Switch AM/PM at 12:00
                    if (hh == 8'b00010100) begin // 12 in BCD + 1
                        pm <= 1'b1; // Switch to PM
                    end else if (hh == 8'b00010010 + 12) begin // 12 in BCD + 12
                        pm <= 1'b0; // Switch to AM
                    end
                end
            end else begin
                mm <= mm + 1; // Increment minutes
            end
        end else begin
            ss <= ss + 1; // Increment seconds
        end
    end
end

endmodule