module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] hours_reg; // hours in binary (0-23)
reg [5:0] minutes_reg; // minutes in binary (0-59)
reg [5:0] seconds_reg; // seconds in binary (0-59)
reg pm_reg; // pm indicator

always @(posedge clk) begin
    if (reset) begin
        hours_reg <= 0; // reset to 12:00 AM
        minutes_reg <= 0;
        seconds_reg <= 0;
        pm_reg <= 0; // AM
    end else if (ena) begin
        if (seconds_reg == 59) begin
            seconds_reg <= 0;
            if (minutes_reg == 59) begin
                minutes_reg <= 0;
                if (hours_reg == 23) begin
                    hours_reg <= 0; // wrap around to 12:00 AM
                    pm_reg <= 0; // AM
                end else if (hours_reg == 12) begin
                    hours_reg <= 1; // 1 PM
                    pm_reg <= 1; // PM
                end else if (hours_reg == 11) begin
                    hours_reg <= 12; // 12 PM
                    pm_reg <= 1; // PM
                end else begin
                    hours_reg <= hours_reg + 1;
                    if (hours_reg >= 12) begin
                        pm_reg <= 1; // PM
                    end else begin
                        pm_reg <= 0; // AM
                    end
                end
            end else begin
                minutes_reg <= minutes_reg + 1;
            end
        end else begin
            seconds_reg <= seconds_reg + 1;
        end
    end
end

// convert binary to BCD
assign hh = (hours_reg % 12 == 0) ? 8'b00010010 : (hours_reg % 12 < 10) ? {4'b0000, hours_reg[3:0]} : {4'b0001, hours_reg[3:0] - 10};
assign mm = (minutes_reg < 10) ? {4'b0000, minutes_reg[3:0]} : {4'b0001, minutes_reg[3:0] - 10};
assign ss = (seconds_reg < 10) ? {4'b0000, seconds_reg[3:0]} : {4'b0001, seconds_reg[3:0] - 10};
assign pm = pm_reg;

endmodule