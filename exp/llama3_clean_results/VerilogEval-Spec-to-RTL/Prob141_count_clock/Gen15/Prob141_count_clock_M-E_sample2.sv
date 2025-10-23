module TimeCounter(
    input clk,
    input reset,
    input ena,
    output reg [5:0] seconds,
    output reg [5:0] minutes,
    output reg [3:0] hours,
    output reg pm
);

    always_ff @(posedge clk) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 12 / 10; // Initialize hours to 12 (0 in binary)
            pm <= 0; // AM
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 11) begin // Wrap around from 12 to 1
                        hours <= 1; // After 12, it's 1
                        pm <= ~pm; // Toggle AM/PM
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

endmodule

module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [3:0] hours;
    wire pm_flag;

    TimeCounter time_counter(clk, reset, ena, seconds, minutes, hours, pm_flag);

    // Directly assign the AM/PM flag
    assign pm = pm_flag;

    // Convert binary to BCD and assign to output ports
    assign hh = {4'b0000, hours / 10, hours % 10}; // Hours in 12-hour format
    assign mm = {4'b0000, minutes / 10, minutes % 10};
    assign ss = {4'b0000, seconds / 10, seconds % 10};

endmodule