module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'b000000;
        minutes <= 6'b000000;
        hours <= 4'b1100;     // Reset hours to 12 in BCD format
        pm_flag <= 1'b0;
    end else if (ena) begin
        if (seconds == 6'b111011) begin
            seconds <= 6'b000000;
            if (minutes == 6'b111011) begin
                minutes <= 6'b000000;
                if (hours == 4'b1100) begin
                    hours <= 4'b0001; // 1 in BCD
                    pm_flag <= ~pm_flag;
                end else if (hours == 4'b1001) begin // 9 in BCD
                    hours <= 4'b1010; // 10 in BCD (A in hex, but we use A for 10 in BCD)
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

// Corrected BCD encoding logic
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0000};
assign mm = {minutes[5], minutes[4], minutes[3], minutes[2], minutes[1], minutes[0], 2'b00};
assign ss = {seconds[5], seconds[4], seconds[3], seconds[2], seconds[1], seconds[0], 2'b00};

assign pm = pm_flag;

endmodule