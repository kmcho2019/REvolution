module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD counters for seconds
    reg [3:0] sec_units;  // 0-9
    reg [2:0] sec_tens;   // 0-5 (3 bits enough)

    // BCD counters for minutes
    reg [3:0] min_units;  // 0-9
    reg [2:0] min_tens;   // 0-5

    // BCD counters for hours
    reg [3:0] hr_units;   // 0-9 (will count 1..2 for tens digit)
    reg [1:0] hr_tens;    // 0-1 (hours range 01..12)

    // Helper to compare if hour == 12
    wire hour_is_12 = (hr_tens == 2'd1) && (hr_units == 4'd2);
    // Helper to compare if hour == 11
    wire hour_is_11 = (hr_tens == 2'd1) && (hr_units == 4'd1);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm        <= 1'b0;       // AM
            sec_units <= 4'd0;
            sec_tens  <= 3'd0;
            min_units <= 4'd0;
            min_tens  <= 3'd0;
            hr_tens   <= 2'd1;       // tens digit of 12 is 1
            hr_units  <= 4'd2;       // units digit 2
        end else if (ena) begin
            // Increment seconds units
            if (sec_units == 4'd9) begin
                sec_units <= 4'd0;
                // Increment seconds tens
                if (sec_tens == 3'd5) begin
                    sec_tens <= 3'd0;
                    // Increment minutes units
                    if (min_units == 4'd9) begin
                        min_units <= 4'd0;
                        // Increment minutes tens
                        if (min_tens == 3'd5) begin
                            min_tens <= 3'd0;
                            // Increment hours (BCD 12-hour)
                            if (hour_is_12) begin
                                hr_tens <= 2'd0;
                                hr_units <= 4'd1;
                                pm <= ~pm; // Toggle AM/PM at 12 rollover
                            end else if (hour_is_11) begin
                                hr_tens <= 2'd1;
                                hr_units <= 4'd2;
                            end else begin
                                // Increment hours normally
                                if (hr_units == 4'd9) begin
                                    hr_units <= 4'd0;
                                    hr_tens <= hr_tens + 1'b1;
                                end else begin
                                    hr_units <= hr_units + 1'b1;
                                end
                            end
                        end else begin
                            min_tens <= min_tens + 1'b1;
                        end
                    end else begin
                        min_units <= min_units + 1'b1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1'b1;
                end
            end else begin
                sec_units <= sec_units + 1'b1;
            end
        end
    end

    // Drive output ports from counters
    always @* begin
        // Hours: top nibble tens, bottom nibble units
        hh = {hr_tens, hr_units};
        // Minutes
        mm = {min_tens, min_units};
        // Seconds
        ss = {sec_tens, sec_units};
    end

endmodule