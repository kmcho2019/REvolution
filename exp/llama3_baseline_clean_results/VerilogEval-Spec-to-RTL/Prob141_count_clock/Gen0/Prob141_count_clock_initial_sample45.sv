module TopModule(
    input           clk,
    input           reset,
    input           ena,
    output          pm,
    output [7:0]    hh,
    output [7:0]    mm,
    output [7:0]    ss
);

reg [5:0] seconds;  // 0-59
reg [5:0] minutes;  // 0-59
reg [3:0] hours;    // 1-12
reg        is_pm;   // AM/PM indicator

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours   <= 1;  // Reset to 12:00 AM
        is_pm  <= 0;
    end else if (ena) begin
        // Increment seconds counter
        seconds <= seconds + 1;
        
        if (seconds == 60) begin  // Wrap around seconds counter
            seconds <= 0;
            // Increment minutes counter
            minutes <= minutes + 1;
            
            if (minutes == 60) begin  // Wrap around minutes counter
                minutes <= 0;
                // Increment hours counter
                if (hours == 12) begin
                    hours   <= 1;  // Wrap around hours counter
                    is_pm  <= ~is_pm;  // Toggle AM/PM
                end else begin
                    hours   <= hours + 1;
                end
            end
        end
    end
end

assign ss = seconds[5:0];  // Output seconds as BCD
assign mm = minutes[5:0];  // Output minutes as BCD
assign hh = {hours[3], hours[2:0]};  // Output hours as BCD
assign pm = is_pm;

endmodule