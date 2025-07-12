module TopModule(
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

always @ (posedge clk) begin
    if (reset) begin
        hours <= 4'd12;  // Initial hour value is 12
        minutes <= 6'd0;
        seconds <= 6'd0;
        pm_reg <= 1'b0;  // Initial am/pm value is AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd12) begin
                    hours <= 4'd1;
                    pm_reg <= ~pm_reg;  // Toggle am/pm
                end else if (hours == 4'd12 - 1) begin
                    hours <= 4'd12;
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

assign pm = pm_reg;
assign hh = (hours < 4'd10) ? {4'b0000, hours} : {4'b0001, hours - 4'd10};
assign mm = (minutes < 6'd10) ? {2'b00, minutes} : {2'b01, minutes - 6'd10};
assign ss = (seconds < 6'd10) ? {2'b00, seconds} : {2'b01, seconds - 6'd10};

endmodule