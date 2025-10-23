module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours; // Hours in 0-11 format for simplicity
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0; // Initialize hours to 0 (12 AM)
        am_pm <= 1'b0; // Initialize AM/PM to AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0; // Roll over to 0 (12 AM)
                    am_pm <= 1'b0; // Switch to AM
                end else if (hours == 4'd11 && am_pm == 1'b1) begin
                    hours <= 4'd0; // Midnight
                    am_pm <= 1'b0; // Switch to AM
                end else if (hours == 4'd5 && am_pm == 1'b0) begin // Noon
                    hours <= 4'd6; // 6 in 0-11 format represents 12 PM
                    am_pm <= 1'b1; // Switch to PM
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

// Convert hours, minutes, seconds to BCD
assign hh = (hours == 4'd0) ? 8'd12 : (hours < 4'd10) ? {4'd0, hours} : {4'd1, hours - 4'd10}; // Correct 12-hour BCD conversion
assign mm = minutes[5:4] * 8'd10 + minutes[3:0]; // Standard BCD conversion for minutes
assign ss = seconds[5:4] * 8'd10 + seconds[3:0]; // Standard BCD conversion for seconds
assign pm = am_pm;

endmodule