module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;
    reg pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 0; // 12:00 AM
            minutes <= 0;
            seconds <= 0;
            pm_reg <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 11) begin
                        hours <= 0;
                        pm_reg <= ~pm_reg; // Toggle AM/PM
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

    assign hh = (hours == 0) ? 8'b0001_0010 : (hours < 10) ? {1'b0, hours, 4'b0000} : {1'b1, hours - 10, 4'b0000};
    assign mm = (minutes < 10) ? {5'b00000, minutes} : {4'b0000, minutes - 10, 2'b00} + {4'b0000, 10, 2'b00};
    assign ss = (seconds < 10) ? {5'b00000, seconds} : {4'b0000, seconds - 10, 2'b00} + {4'b0000, 10, 2'b00};
    assign pm = pm_reg;

endmodule