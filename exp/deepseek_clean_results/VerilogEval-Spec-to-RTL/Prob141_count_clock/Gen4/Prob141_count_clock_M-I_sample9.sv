module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Seconds counter (0-59)
    reg [5:0] seconds;
    wire sec_ena = ena;
    wire min_ena = (seconds == 6'd59) & sec_ena;

    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
        end else if (sec_ena) begin
            seconds <= (seconds == 6'd59) ? 6'd0 : seconds + 1;
        end
    end

    // Minutes counter (0-59)
    reg [5:0] minutes;
    wire hr_ena = (minutes == 6'd59) & min_ena;

    always @(posedge clk) begin
        if (reset) begin
            minutes <= 6'd0;
        end else if (min_ena) begin
            minutes <= (minutes == 6'd59) ? 6'd0 : minutes + 1;
        end
    end

    // Hours counter (1-12)
    reg [3:0] hours;
    reg pm_reg;
    wire hour_rollover = (hours == 4'd12) & hr_ena;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 4'd12;
            pm_reg <= 1'b0;
        end else if (hr_ena) begin
            if (hour_rollover) begin
                hours <= 4'd1;
            end else begin
                hours <= hours + 1;
            end
        end
    end

    // PM indicator (toggles at 11->12 transition)
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end else if (hours == 4'd11 && hr_ena) begin
            pm_reg <= ~pm_reg;
        end
    end

    // BCD conversion functions
    function [7:0] to_bcd;
        input [5:0] val;
        begin
            to_bcd = {(val / 10), (val % 10)};
        end
    endfunction

    function [7:0] hour_to_bcd;
        input [3:0] h;
        begin
            hour_to_bcd = (h == 4'd0) ? 8'h12 : 
                         (h > 4'd9) ? {4'd1, h - 4'd10} : 
                         {4'd0, h};
        end
    endfunction

    // Output assignments
    assign ss = to_bcd(seconds);
    assign mm = to_bcd(minutes);
    assign hh = hour_to_bcd(hours);
    assign pm = pm_reg;

endmodule