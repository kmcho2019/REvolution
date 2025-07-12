module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

parameter BCD_0 = 4'b0000;
parameter BCD_1 = 4'b0001;
parameter BCD_2 = 4'b0010;
parameter BCD_3 = 4'b0011;
parameter BCD_4 = 4'b0100;
parameter BCD_5 = 4'b0101;
parameter BCD_6 = 4'b0110;
parameter BCD_7 = 4'b0111;
parameter BCD_8 = 4'b1000;
parameter BCD_9 = 4'b1001;

reg [3:0] hours_tens;
reg [3:0] hours_units;
reg [3:0] minutes_tens;
reg [3:0] minutes_units;
reg [3:0] seconds_tens;
reg [3:0] seconds_units;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= BCD_1; // 1 in BCD
        hours_units <= BCD_2; // 2 in BCD
        minutes_tens <= BCD_0; // 0 in BCD
        minutes_units <= BCD_0; // 0 in BCD
        seconds_tens <= BCD_0; // 0 in BCD
        seconds_units <= BCD_0; // 0 in BCD
        pm_flag <= 1'b0;
    end else if (ena) begin
        if (seconds_units == BCD_9) begin
            seconds_units <= BCD_0;
            if (seconds_tens == BCD_5) begin
                seconds_tens <= BCD_0;
                if (minutes_units == BCD_9) begin
                    minutes_units <= BCD_0;
                    if (minutes_tens == BCD_5) begin
                        minutes_tens <= BCD_0;
                        if (hours_units == BCD_2 && hours_tens == BCD_1 && pm_flag == 1'b1) begin // 12 PM
                            hours_tens <= BCD_1;
                            hours_units <= BCD_1;
                            pm_flag <= 1'b0;
                        end else if (hours_units == BCD_2 && hours_tens == BCD_1 && pm_flag == 1'b0) begin // 12 AM
                            hours_tens <= BCD_1;
                            hours_units <= BCD_2;
                            pm_flag <= 1'b1;
                        end else if (hours_tens == BCD_0 && hours_units == BCD_9) begin
                            hours_tens <= BCD_1;
                            hours_units <= BCD_0;
                        end else if (hours_tens == BCD_1 && hours_units == BCD_2) begin
                            hours_tens <= BCD_0;
                            hours_units <= BCD_1;
                            pm_flag <= ~pm_flag;
                        end else begin
                            hours_units <= hours_units + 1;
                        end
                    end else begin
                        minutes_units <= minutes_units + 1;
                    end
                end else begin
                    minutes_tens <= minutes_tens + 1;
                end
            end else begin
                seconds_units <= seconds_units + 1;
            end
        end else begin
            seconds_units <= seconds_units + 1;
        end
    end
end

assign hh = {hours_tens, hours_units, 4'b0000};
assign mm = {minutes_tens, minutes_units, 4'b0000};
assign ss = {seconds_tens, seconds_units, 4'b0000};
assign pm = pm_flag;

endmodule