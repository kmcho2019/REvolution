module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds; // BCD for seconds (00-59)
reg [3:0] minutes; // BCD for minutes (00-59)
reg [3:0] hours;   // BCD for hours (01-12)
reg pm_state;      // 1 for PM, 0 for AM

always @(posedge clk) begin
    if (reset) begin // Reset condition
        seconds <= 0;
        minutes <= 0;
        hours <= 1; // Default to 1 (01) for AM
        pm_state <= 0; // Reset to AM
    end else if (ena) begin // Increment condition
        if (seconds == 9'h59) begin // 59 seconds, increment minutes
            seconds <= 0;
            if (minutes == 9'h59) begin // 59 minutes, increment hours
                minutes <= 0;
                if (hours == 9'h12) begin // Wrap around hours
                    hours <= 1; // 01
                    pm_state <= ~pm_state; // Toggle AM/PM
                end else if (hours == 9'h11) begin // 11 to 12
                    hours <= 9'h12;
                    pm_state <= 1'b1; // Switch to PM
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

assign hh = {4'h1, hours}; // Output hours in BCD format, assuming upper 4 bits are always 0001 for 01-12
assign mm = {4'h0, minutes}; // Output minutes in BCD format
assign ss = {4'h0, seconds}; // Output seconds in BCD format
assign pm = pm_state; // Output PM state

endmodule