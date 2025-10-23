// Define a module for seconds, minutes, and hours counters
module Counters (
    input clk,
    input reset,
    input ena,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss,
    output reg pm
);

    reg [5:0] seconds;
    reg [5:0] minutes;
    reg [3:0] hours;
    reg pm_flag;

    // Use non-blocking assignments for better performance
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 1; // Reset to 12:00:00 AM
            pm_flag <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1;
                        pm_flag <= ~pm_flag;
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

    // Use a lookup table for binary_to_bcd
    reg [7:0] binary_to_bcd [0:59];
    initial begin
        for (int i = 0; i <= 59; i++) begin
            binary_to_bcd[i] = {4'b0000, i / 10, i % 10};
        end
    end

    // Assign outputs
    assign hh = {4'b0000, hours};
    assign mm = binary_to_bcd[minutes];
    assign ss = binary_to_bcd[seconds];
    assign pm = pm_flag;

endmodule

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

    // Instantiate the Counters module
    Counters counters_mod(clk, reset, ena, hh, mm, ss, pm);

endmodule