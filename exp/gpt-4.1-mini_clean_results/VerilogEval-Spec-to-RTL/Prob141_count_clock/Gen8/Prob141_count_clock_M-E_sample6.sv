module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Total seconds in 12 hours: 12*3600 = 43200 seconds, counter range 0..43199
    reg [15:0] total_seconds; // 16 bits enough for max 43200

    // Function: convert binary value (0..59) to BCD (two digits)
    function [7:0] bin_to_bcd_2dig;
        input [5:0] val; // max 59
        reg [3:0] tens;
        reg [3:0] ones;
        begin
            tens = val / 10;
            ones = val % 10;
            bin_to_bcd_2dig = {tens, ones};
        end
    endfunction

    // Function: convert binary hour (1..12) to BCD
    function [7:0] hour_bin_to_bcd;
        input [3:0] hr; // 1..12
        reg [3:0] tens;
        reg [3:0] ones;
        begin
            if (hr < 10) begin
                tens = 4'd0;
                ones = hr[3:0];
            end else begin
                tens = 4'd1;
                ones = hr - 4'd10;
            end
            hour_bin_to_bcd = {tens, ones};
        end
    endfunction

    // Calculate hours (1..12), minutes (0..59), seconds (0..59)
    wire [15:0] seconds_mod_12h = total_seconds % 16'd43200; // Wrap not really needed because total_seconds capped
    wire [15:0] seconds_in_12h = (total_seconds < 16'd43200) ? total_seconds : total_seconds - 16'd43200;

    wire [15:0] seconds_in_period = seconds_in_12h;

    // Hour calculation
    // hours zero-based = total_seconds / 3600 % 12, but 0 means 12.
    wire [3:0] hour_zero_based = (seconds_in_period / 3600) % 12; 
    wire [3:0] hour_12h = (hour_zero_based == 0) ? 4'd12 : hour_zero_based;

    wire [5:0] minute = (seconds_in_period % 3600) / 60;
    wire [5:0] second = seconds_in_period % 60;

    // pm = 1 if total_seconds >= 12*3600/2 = 21600 (6 hours)
    // But since clock counts 0..43199 for 12 hours,
    // AM = 0..21599, PM = 21600..43199
    wire pm_next = (total_seconds >= 16'd21600);

    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 16'd0;
            pm <= 1'b0;      // 12:00 AM
        end else if (ena) begin
            if (total_seconds == 16'd43199)
                total_seconds <= 16'd0;
            else
                total_seconds <= total_seconds + 16'd1;

            pm <= (total_seconds == 16'd43199) ? 1'b0 : pm_next; 
            // pm toggles at roll-over from 11:59:59 PM (43199) to 12:00:00 AM (0)
            // Actually pm_next covers that except at rollover, so reset to 0 at rollover.
        end
    end

    // Combinational outputs of hh, mm, ss
    always @(*) begin
        hh = hour_bin_to_bcd(hour_12h);
        mm = bin_to_bcd_2dig(minute);
        ss = bin_to_bcd_2dig(second);
    end

endmodule