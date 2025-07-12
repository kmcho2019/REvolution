module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// internal signals
reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;
reg pm_int;

// initial values
initial begin
    seconds = 8'b00000000; // 00 in BCD
    minutes = 8'b00000000; // 00 in BCD
    hours = 8'b00010001; // 12 in BCD
    pm_int = 1'b0; // AM
end

// synchronous logic
always @(posedge clk) begin
    if (reset) begin
        seconds <= 8'b00000000; // 00 in BCD
        minutes <= 8'b00000000; // 00 in BCD
        hours <= 8'b00010001; // 12 in BCD
        pm_int <= 1'b0; // AM
    end else if (ena) begin
        // increment seconds
        if (seconds == 8'b01011001) begin // 59 in BCD
            seconds <= 8'b00000000; // 00 in BCD
            // increment minutes
            if (minutes == 8'b01011001) begin // 59 in BCD
                minutes <= 8'b00000000; // 00 in BCD
                // increment hours
                if (hours == 8'b00010010) begin // 01 in BCD (1 AM)
                    hours <= 8'b00010001; // 12 in BCD
                    pm_int <= 1'b0; // AM
                end else if (hours == 8'b00010001) begin // 12 in BCD
                    hours <= 8'b00010010; // 01 in BCD
                    pm_int <= 1'b1; // PM
                end else if (hours == 8'b00010100) begin // 12 in BCD (12 PM)
                    hours <= 8'b00010001; // 01 in BCD
                    pm_int <= 1'b0; // AM
                end else begin
                    // increment hours (2-11 AM/PM)
                    if (hours[3:0] == 4'b1001) begin // 9 in BCD
                        hours[3:0] <= 4'b0000; // 0 in BCD
                        hours[7:4] <= hours[7:4] + 1'b1;
                    end else begin
                        hours[3:0] <= hours[3:0] + 1'b1;
                    end
                end
            end else begin
                // increment minutes
                if (minutes[3:0] == 4'b1001) begin // 9 in BCD
                    minutes[3:0] <= 4'b0000; // 0 in BCD
                    minutes[7:4] <= minutes[7:4] + 1'b1;
                end else begin
                    minutes[3:0] <= minutes[3:0] + 1'b1;
                end
            end
        end else begin
            // increment seconds
            if (seconds[3:0] == 4'b1001) begin // 9 in BCD
                seconds[3:0] <= 4'b0000; // 0 in BCD
                seconds[7:4] <= seconds[7:4] + 1'b1;
            end else begin
                seconds[3:0] <= seconds[3:0] + 1'b1;
            end
        end
    end
end

// output assignments
assign pm = pm_int;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule