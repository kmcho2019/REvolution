module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

always @(posedge clk) begin
    if (reset) begin
        hours <= 0; // 12:00 AM
        minutes <= 0;
        seconds <= 0;
        pm <= 0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours
                if (hours == 11) begin
                    hours <= 0; // Wrap around to 12 (AM)
                    pm <= 0; // AM
                end else if (hours == 12) begin
                    hours <= 1; // 1 PM
                    pm <= 1; // PM
                end else begin
                    hours <= hours + 1;
                    pm <= (hours > 11) ? 1'b1 : 1'b0; // Update PM
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Convert to BCD and output
assign hh = (hours == 0) ? 8'h12 : (hours > 12) ? (hours - 12) : hours;
assign mm = (minutes < 10) ? {4'h0, minutes} : minutes;
assign ss = (seconds < 10) ? {4'h0, seconds} : seconds;

endmodule