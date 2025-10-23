// Define the TopModule
module TopModule (
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

    // Use non-blocking assignments for better performance
    always @(posedge clk) begin
        if (reset) begin
            hours <= 0; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 11) begin // 11 because hours starts from 0 for 12:00 AM
                        hours <= 0;
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

    // Derive the 'pm' output directly from the hours counter
    assign pm = (hours >= 6); // Since hours starts from 0 for 12:00 AM

    // Assign outputs, casting division and modulus results to specific bit widths
    assign hh = {4'b0000, hours};
    assign mm = {4'b0000, 4'b0000 | (minutes / 10), 4'b0000 | (minutes % 10)};
    assign ss = {4'b0000, 4'b0000 | (seconds / 10), 4'b0000 | (seconds % 10)};

endmodule