module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'b00010010; // 12 in BCD
        minutes <= 8'b00000000; // 00 in BCD
        seconds <= 8'b00000000; // 00 in BCD
        pm_reg <= 0;
    end else if (ena) begin
        if (seconds == 8'b01111000) begin // 60 in BCD
            seconds <= 8'b00000000; // 00 in BCD
            if (minutes == 8'b01111000) begin // 60 in BCD
                minutes <= 8'b00000000; // 00 in BCD
                if (hours == 8'b00010011) begin // 13 in BCD (1 PM)
                    hours <= 8'b00000001; // 01 in BCD
                    pm_reg <= 1;
                end else if (hours == 8'b00010010) begin // 12 in BCD
                    hours <= 8'b00010011; // 13 in BCD (1 PM)
                    pm_reg <= 1;
                end else begin
                    hours <= hours + 1;
                    if (hours >= 8'b00010010) begin // 12 in BCD
                        pm_reg <= 1;
                    end else begin
                        pm_reg <= 0;
                    end
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

assign pm = pm_reg;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule