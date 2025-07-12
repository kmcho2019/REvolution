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
    reg pm_state;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 1; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
            pm_state <= 0; // AM
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1;
                        pm_state <= ~pm_state; // Toggle AM/PM
                    end else if (hours == 11) begin
                        hours <= 12;
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

    assign pm = pm_state;
    assign hh = (hours < 10) ? {4'b0000, hours} : {4'b0000, hours / 10, 4'b0000, hours % 10};
    assign mm = (minutes < 10) ? {6'b000000, minutes} : {4'b0000, minutes / 10, 4'b0000, minutes % 10};
    assign ss = (seconds < 10) ? {6'b000000, seconds} : {4'b0000, seconds / 10, 4'b0000, seconds % 10};

endmodule