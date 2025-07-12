module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [5:0] seconds;  // 0-59
    reg [5:0] minutes;  // 0-59
    reg [3:0] hours;    // 1-12
    reg pm_reg;

    // BCD conversion
    assign ss = {(seconds/10), (seconds%10)};
    assign mm = {(minutes/10), (minutes%10)};
    assign hh = (hours == 12) ? 8'h12 : 
               (hours < 10) ? {4'h0, hours} : {4'h1, hours-10};
    assign pm = pm_reg;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            minutes <= 6'd0;
        end else if (ena && seconds == 6'd59) begin
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
            end else begin
                minutes <= minutes + 1;
            end
        end
    end

    // Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hours <= 4'd12;
            pm_reg <= 1'b0;
        end else if (ena && seconds == 6'd59 && minutes == 6'd59) begin
            if (hours == 4'd12) begin
                hours <= 4'd1;
                pm_reg <= ~pm_reg;
            end else begin
                hours <= hours + 1;
            end
        end
    end

endmodule