module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [31:0] sec_counter; // counter for seconds, reset to 0

    always @(posedge clk) begin
        if (reset) begin
            // Reset the clock to 12:00 AM
            pm <= 1'b0; // AM
            hh <= 8'b00010010; // 12 in BCD
            mm <= 8'b00000000; // 00 in BCD
            ss <= 8'b00000000; // 00 in BCD
            sec_counter <= 32'd0;
        end else if (ena) begin
            // Increment the clock by one second
            sec_counter <= sec_counter + 1;

            // Update the seconds counter
            if (sec_counter == 32'd0) begin
                // If seconds is 59, increment minutes
                if (ss == 8'b01011001) begin // 59 in BCD
                    ss <= 8'b00000000; // 00 in BCD
                    // If minutes is 59, increment hours
                    if (mm == 8'b01011001) begin // 59 in BCD
                        mm <= 8'b00000000; // 00 in BCD
                        // If hours is 12, toggle AM/PM and reset hours
                        if (hh == 8'b00010010 && pm == 1'b1) begin // 12 PM in BCD
                            hh <= 8'b00010001; // 01 in BCD
                            pm <= 1'b0; // AM
                        end else if (hh == 8'b00010010 && pm == 1'b0) begin // 12 AM in BCD
                            hh <= 8'b00010010; // 12 in BCD
                            pm <= 1'b1; // PM
                        end else if (hh == 8'b00010001) begin // 01 in BCD
                            hh <= 8'b00010010; // 12 in BCD
                            pm <= 1'b1; // PM
                        end else begin
                            // Increment hours
                            if (hh[3:0] == 4'b1001) begin // 9 in BCD
                                hh[3:0] <= 4'b0000; // 0 in BCD
                                hh[7:4] <= hh[7:4] + 1;
                            end else begin
                                hh[3:0] <= hh[3:0] + 1;
                            end
                        end
                    end else begin
                        // Increment minutes
                        if (mm[3:0] == 4'b1001) begin // 9 in BCD
                            mm[3:0] <= 4'b0000; // 0 in BCD
                            mm[7:4] <= mm[7:4] + 1;
                        end else begin
                            mm[3:0] <= mm[3:0] + 1;
                        end
                    end
                end else begin
                    // Increment seconds
                    if (ss[3:0] == 4'b1001) begin // 9 in BCD
                        ss[3:0] <= 4'b0000; // 0 in BCD
                        ss[7:4] <= ss[7:4] + 1;
                    end else begin
                        ss[3:0] <= ss[3:0] + 1;
                    end
                end
            end
        end
    end

endmodule