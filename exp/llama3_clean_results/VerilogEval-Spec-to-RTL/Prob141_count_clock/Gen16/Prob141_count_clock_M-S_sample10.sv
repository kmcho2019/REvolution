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

    reg [3:0] hours; // Hours in 12-hour format (1-12)
    reg [5:0] minutes; // Minutes (0-59)
    reg [5:0] seconds; // Seconds (0-59)

    always @(posedge clk) begin
        if (reset) begin
            hours <= 1; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1; // Wrap around from 12 to 1
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
    assign pm = (hours >= 7 && hours <= 12) || hours == 0;

    // Assign outputs with explicit bit width for division and modulus results
    assign hh = {4'b0000, hours};
    assign mm = {4'b0000, (minutes / 10), minutes % 10};
    assign ss = {4'b0000, (seconds / 10), seconds % 10};

endmodule