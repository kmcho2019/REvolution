module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;
reg [3:0] minutes;
reg [3:0] hours;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'b0000; // 0 in BCD
        minutes <= 4'b0000; // 0 in BCD
        hours <= 4'b0001;   // 1 in BCD (12 AM)
        pm_reg <= 1'b0;     // AM
    end else if (ena) begin
        if (seconds == 4'b0100) begin // 60 in decimal
            seconds <= 4'b0000; // 0 in BCD
            if (minutes == 4'b1000) begin // 60 in decimal
                minutes <= 4'b0000; // 0 in BCD
                if (hours == 4'b1001) begin // 13 in decimal (1 PM)
                    hours <= 4'b0001;   // 1 in BCD (1 AM)
                    pm_reg <= 1'b0;     // AM
                end else if (hours == 4'b0100) begin // 12 in decimal
                    hours <= 4'b0001;   // 1 in BCD
                    pm_reg <= 1'b1;     // PM
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

assign hh = {hours[3:2], hours[1:0]};
assign mm = {minutes[3:2], minutes[1:0]};
assign ss = {seconds[3:2], seconds[1:0]};
assign pm = pm_reg;

endmodule