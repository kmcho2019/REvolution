module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;  // 4 bits to represent 0-9 for BCD
reg [3:0] minutes_tens;  // 4 bits to represent 0-5 for BCD tens place
reg [3:0] minutes_ones;  // 4 bits to represent 0-9 for BCD ones place
reg [3:0] hours_tens;  // 4 bits to represent 0-1 for BCD tens place
reg [3:0] hours_ones;  // 4 bits to represent 0-2 for BCD ones place
reg pm_state;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes_tens <= 0;
        minutes_ones <= 0;
        hours_tens <= 0;
        hours_ones <= 1;  // 12 in BCD
        pm_state <= 0;  // AM
    end else if (ena) begin
        if (seconds == 9) begin
            seconds <= 0;
            if (minutes_ones == 9) begin
                minutes_ones <= 0;
                if (minutes_tens == 5) begin
                    minutes_tens <= 0;
                    if (hours_ones == 2 && hours_tens == 1) begin
                        hours_ones <= 1;
                        hours_tens <= 0;
                        pm_state <= 0;  // AM
                    end else if (hours_ones == 9 && hours_tens == 1) begin
                        hours_ones <= 0;
                        hours_tens <= 0;
                        pm_state <= 1;  // PM
                    end else if (hours_ones == 2 && hours_tens == 0) begin
                        hours_ones <= 1;
                        hours_tens <= 0;
                        pm_state <= 1;  // PM
                    end else begin
                        hours_ones <= hours_ones + 1;
                        if (hours_ones > 2) begin
                            hours_ones <= 0;
                            hours_tens <= hours_tens + 1;
                        end
                        if (hours_tens == 1 && hours_ones > 2) begin
                            hours_tens <= 0;
                            hours_ones <= 1;
                            pm_state <= 1;  // PM
                        end
                    end
                end else begin
                    minutes_tens <= minutes_tens + 1;
                end
            end else begin
                minutes_ones <= minutes_ones + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

assign pm = pm_state;
assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {4'b0, seconds};

endmodule