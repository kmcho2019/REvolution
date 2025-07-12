module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours_tens;
reg [3:0] hours_units;
reg [3:0] minutes_tens;
reg [3:0] minutes_units;
reg [3:0] seconds_tens;
reg [3:0] seconds_units;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 4'b0001; // 1 in BCD
        hours_units <= 4'b0010; // 2 in BCD
        minutes_tens <= 4'b0000; // 0 in BCD
        minutes_units <= 4'b0000; // 0 in BCD
        seconds_tens <= 4'b0000; // 0 in BCD
        seconds_units <= 4'b0000; // 0 in BCD
        pm_flag <= 1'b0;
    end else if (ena) begin
        if (seconds_units == 4'b1001) begin // 9 in BCD
            seconds_units <= 4'b0000; // 0 in BCD
            if (seconds_tens == 4'b0101) begin // 5 in BCD
                seconds_tens <= 4'b0000; // 0 in BCD
                if (minutes_units == 4'b1001) begin // 9 in BCD
                    minutes_units <= 4'b0000; // 0 in BCD
                    if (minutes_tens == 4'b0101) begin // 5 in BCD
                        minutes_tens <= 4'b0000; // 0 in BCD
                        if (hours_units == 4'b1010) begin // 10 in BCD (A in hex, but we use A for 10 in BCD)
                            hours_units <= 4'b0001; // 1 in BCD
                            pm_flag <= ~pm_flag;
                        end else if (hours_units == 4'b0011 && pm_flag == 1'b1) begin // 3 in BCD (3 PM) and it is PM
                            hours_tens <= 4'b0001; // 1 in BCD
                            hours_units <= 4'b0010; // 2 in BCD
                            pm_flag <= 1'b0;
                        end else begin
                            if (hours_tens == 4'b0001 && hours_units == 4'b1000) begin // 12 in BCD
                                hours_tens <= 4'b0001; // 1 in BCD
                                hours_units <= 4'b0001; // 1 in BCD
                            end else begin
                                hours_units <= hours_units + 1;
                            end
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