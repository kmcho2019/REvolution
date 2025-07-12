module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Define the counters
reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

// Initialize the counters
initial begin
    hours = 4'b1000; // Initial hours in BCD (12)
    minutes = 6'b000000; // Initial minutes in BCD (00)
    seconds = 6'b000000; // Initial seconds in BCD (00)
    pm = 1'b0; // Initial AM/PM flag (AM)
end

// Define the reset logic
always @(posedge clk) begin
    if (reset) begin
        hours <= 4'b1000; // Reset hours to 12 (1000 in BCD)
        minutes <= 6'b000000; // Reset minutes to 00 (000000 in BCD)
        seconds <= 6'b000000; // Reset seconds to 00 (000000 in BCD)
        pm <= 1'b0; // Reset to AM
    end
end

// Define the increment logic
always @(posedge clk) begin
    if (!reset && ena) begin
        // Increment the seconds counter
        if (seconds == 6'b010011) begin // 59 in BCD
            seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
            // Increment the minutes counter
            if (minutes == 6'b010011) begin // 59 in BCD
                minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
                // Increment the hours counter
                if (hours == 4'b1000) begin // 12 in BCD
                    hours <= 4'b0001; // Wrap hours to 01 (1 in BCD)
                    pm <= ~pm; // Toggle AM/PM
                end else if (hours == 4'b1001) begin // 1 in BCD and PM
                    hours <= 4'b1000; // Wrap hours to 12 (12 in BCD)
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1; // Increment hours
                end
            end else begin
                minutes <= minutes + 1; // Increment minutes
            end
        end else begin
            seconds <= seconds + 1; // Increment seconds
        end
    end
end

// Assign the output signals
assign hh = {4'b0000, hours}; // Drive hh from hours
assign mm = {2'b00, minutes}; // Drive mm from minutes
assign ss = {2'b00, seconds}; // Drive ss from seconds

endmodule