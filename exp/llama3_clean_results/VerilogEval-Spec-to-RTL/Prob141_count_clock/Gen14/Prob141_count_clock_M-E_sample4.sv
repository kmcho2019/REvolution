module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours; // 1-12 for 12-hour format
reg [5:0] minutes;
reg [5:0] seconds;
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 12; // Reset hours to 12
        minutes <= 0;
        seconds <= 0;
        am_pm <= 0; // Reset to AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 12) begin
                    hours <= 1;
                    am_pm <= ~am_pm; // Switch AM/PM
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

// Convert binary to BCD directly in the output assignment
assign hh = {4'b0000, (hours / 10), (hours % 10)};
assign mm = {4'b0000, (minutes / 10), (minutes % 10)};
assign ss = {4'b0000, (seconds / 10), (seconds % 10)};
assign pm = am_pm;

endmodule