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
        seconds <= 4'b0000;
        minutes <= 4'b0000;
        hours <= 4'b0001; // 12 hours
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 4'b10011) begin // 59
            seconds <= 4'b0000;
            if (minutes == 4'b10011) begin // 59
                minutes <= 4'b0000;
                if (hours == 4'b1001) begin // 12 PM
                    hours <= 4'b0001; // 1 AM
                    pm_reg <= 1'b0;
                end else if (hours == 4'b0010) begin // 1 PM
                    hours <= 4'b0011; // 2 PM
                    pm_reg <= 1'b1;
                end else if (hours == 4'b0100) begin // 12 AM
                    hours <= 4'b0101; // 1 PM
                    pm_reg <= 1'b1;
                end else if (hours == 4'b0101) begin // 1 AM
                    hours <= 4'b0110; // 2 AM
                    pm_reg <= 1'b0;
                end else begin
                    hours <= hours + 1;
                    if (hours >= 4'b1000) begin // 12
                        pm_reg <= ~pm_reg;
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
assign hh = {4'b0000, hours};
assign mm = {4'b0000, minutes};
assign ss = {4'b0000, seconds};

endmodule