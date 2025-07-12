module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;  // 0-59
reg [3:0] minutes;  // 0-59
reg [3:0] hours;   // 1-12

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 1;
        pm <= 0;
    end else if (ena) begin
        if (seconds == 9'd59) begin
            seconds <= 0;
            if (minutes == 9'd59) begin
                minutes <= 0;
                if (hours == 9'd12) begin
                    hours <= 1;
                    pm <= ~pm;
                end else if (hours == 9'd0) begin
                    hours <= 1;
                    pm <= 0;
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

assign hh = {4'b0, hours};
assign mm = {4'b0, minutes};
assign ss = {4'b0, seconds};
assign pm = (hours > 9'd6);

endmodule