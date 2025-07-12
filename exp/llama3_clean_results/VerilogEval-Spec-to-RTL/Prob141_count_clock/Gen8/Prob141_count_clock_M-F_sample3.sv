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
reg pm_int;

always @(posedge clk) begin
    if (reset) begin
        hours <= 1; // Initial hours (01)
        minutes <= 0; // Initial minutes (00)
        seconds <= 0; // Initial seconds (00)
        pm_int <= 0; // Initial AM/PM flag (AM)
    end else if (ena) begin
        // Increment seconds
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours
                if (hours == 12) begin
                    hours <= 1;
                    pm_int <= ~pm_int; // Toggle AM/PM
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

// Assign the output signals
assign hh = {4'b0000, hours};
assign mm = {2'b00, minutes};
assign ss = {2'b00, seconds};
assign pm = (hours >= 6) ? 1'b1 : 1'b0; // Set pm based on hours

endmodule