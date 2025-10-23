module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [4:0] hours; // Hours in 12-hour format (5 bits to accommodate 12)
reg [5:0] minutes; // Minutes
reg [5:0] seconds; // Seconds
reg am_pm; // AM/PM indicator

always @(posedge clk) begin
    if (reset) begin
        hours <= 5'd12; // Initialize to 12:00 AM
        minutes <= 6'd0;
        seconds <= 6'd0;
        am_pm <= 1'b0; // Initialize to AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 5'd12) begin
                    hours <= 5'd1;
                    am_pm <= 1'b1; // Switch to PM
                end else if (hours == 5'd11) begin
                    hours <= 5'd12;
                    am_pm <= 1'b0; // Switch to AM
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

// Convert hours, minutes, and seconds to BCD
assign hh = {4'd0, hours[3:0]}; // Hours are already in 12-hour format, so just extract the lower 4 bits
assign mm = (minutes[5:4] == 2'b01) ? 8'd10 + minutes[3:0] : (minutes[5:4] == 2'b10) ? 8'd60 : minutes[3:0]; // Correct BCD conversion for minutes
assign ss = (seconds[5:4] == 2'b01) ? 8'd10 + seconds[3:0] : (seconds[5:4] == 2'b10) ? 8'd60 : seconds[3:0]; // Correct BCD conversion for seconds
assign pm = am_pm;

endmodule