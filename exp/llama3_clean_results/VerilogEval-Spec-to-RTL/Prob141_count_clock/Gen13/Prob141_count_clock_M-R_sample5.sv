module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [31:0] seconds_total; // Total seconds since last reset
reg [3:0] hours; // Hours in 12-hour format
reg [5:0] minutes; // Minutes
reg [5:0] seconds; // Seconds

always @(posedge clk) begin
    if (reset) begin
        seconds_total <= 32'd0;
        hours <= 4'd12; // Initialize to 12:00 AM
        minutes <= 6'd0;
        seconds <= 6'd0;
    end else if (ena) begin
        seconds_total <= seconds_total + 1;
        
        // Update minutes and seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Update hours
                if (hours == 4'd12) begin
                    hours <= 4'd1;
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

assign pm = (hours >= 4'd12) ? 1'b1 : 1'b0;

// Convert hours, minutes, and seconds to BCD
assign hh = {4'd0, hours}; // hours already in 12-hour format
assign mm = {2'd0, minutes[5:4]} * 8'd10 + {6'd0, minutes[3:0]}; // convert minutes to BCD
assign ss = {2'd0, seconds[5:4]} * 8'd10 + {6'd0, seconds[3:0]}; // convert seconds to BCD

endmodule