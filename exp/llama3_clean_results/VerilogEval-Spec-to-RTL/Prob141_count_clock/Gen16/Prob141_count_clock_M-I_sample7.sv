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
            hours <= 1; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1;
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
    assign pm = (hours >= 7);

    // Assign outputs with correct BCD conversion
    assign hh = {4'b0000, hours};
    assign mm = {4'b0000, minutes / 10, minutes % 10};
    assign ss = {4'b0000, seconds / 10, seconds % 10};

    // Fix the syntax errors by casting the results to a specific bit width
    // Unfortunately, we cannot directly cast the result of the division or modulus operation to a bit width in Verilog.
    // Instead, we can declare separate variables to hold the results and then assign them to the outputs.
    // However, in this case, we can simplify the code by directly using the binary values of minutes and seconds.

    // Improved version:
    assign hh = (hours < 10) ? {4'b0000, hours} : {4'b0001, hours - 10};
    assign mm = (minutes < 10) ? {4'b0000, minutes} : {4'b0000, minutes / 10, minutes % 10};
    // The above lines will not work as expected because the division and modulus operations do not return a fixed-width result.
    // We will instead use a different approach to convert the binary values to BCD.

    // Improved version using a different approach:
    reg [3:0] minutes_tens;
    reg [3:0] minutes_ones;
    reg [3:0] seconds_tens;
    reg [3:0] seconds_ones;

    always @(posedge clk) begin
        if (reset) begin
            minutes_tens <= 0;
            minutes_ones <= 0;
            seconds_tens <= 0;
            seconds_ones <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds_tens <= 0;
                seconds_ones <= 0;
                if (minutes == 59) begin
                    minutes_tens <= 0;
                    minutes_ones <= 0;
                    if (hours == 12) begin
                        hours <= 1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes_ones <= minutes_ones + 1;
                    if (minutes_ones == 10) begin
                        minutes_ones <= 0;
                        minutes_tens <= minutes_tens + 1;
                    end
                    minutes <= minutes + 1;
                end
            end else begin
                seconds_ones <= seconds_ones + 1;
                if (seconds_ones == 10) begin
                    seconds_ones <= 0;
                    seconds_tens <= seconds_tens + 1;
                end
                seconds <= seconds + 1;
            end
        end
    end

    assign mm = {4'b0000, minutes_tens, minutes_ones};
    assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule