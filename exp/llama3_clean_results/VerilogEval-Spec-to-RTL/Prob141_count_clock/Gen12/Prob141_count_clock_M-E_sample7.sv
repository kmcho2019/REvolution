module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0; // 12 in BCD
        pm <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours
                if (hours == 12) begin // 12 in decimal
                    hours <= 1; // 1 in decimal
                    pm <= 1'b1; // PM
                end else if (hours == 12 + 1) begin // 1 in decimal, 13 in 12-hour format
                    hours <= 2; // 2 in decimal
                end else if (hours == 11 + 1) begin // 12 in decimal, 12 in 12-hour format
                    hours <= 12; // 12 in decimal, 12 in 12-hour format
                    pm <= 1'b0; // AM
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

always @(posedge clk) begin
    // Convert to BCD
    hh <= {hours[3], hours[2], hours[1], hours[0], 1'b0, 1'b0, 1'b0, 1'b0};
    mm <= {minutes[5], minutes[4], minutes[3], minutes[2], 1'b0, 1'b0, 1'b0, 1'b0};
    ss <= {seconds[5], seconds[4], seconds[3], seconds[2], 1'b0, 1'b0, 1'b0, 1'b0};
end

endmodule