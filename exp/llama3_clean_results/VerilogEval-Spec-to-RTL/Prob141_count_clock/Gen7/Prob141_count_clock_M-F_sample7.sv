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
    hours = 4'b0001; // Initial hours in BCD (01)
    minutes = 6'b000000; // Initial minutes in BCD (00)
    seconds = 6'b000000; // Initial seconds in BCD (00)
    pm = 1'b0; // Initial AM/PM flag (AM)
end

// Define the sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset the counters and AM/PM flag
        hours <= 4'b0001; // Reset hours to 01 (1 in BCD)
        minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
        seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
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
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0000};
assign mm = {minutes[5], minutes[4], minutes[3], minutes[2], minutes[1], minutes[0], 2'b00};
assign ss = {seconds[5], seconds[4], seconds[3], seconds[2], seconds[1], seconds[0], 2'b00};

endmodule