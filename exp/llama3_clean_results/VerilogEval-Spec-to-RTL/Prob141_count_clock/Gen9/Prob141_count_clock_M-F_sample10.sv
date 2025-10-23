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

// Define the reset logic
always @(posedge clk) begin
    if (reset) begin
        hours <= 4'b1001; // Reset hours to 01 (1 in BCD)
        minutes <= 6'b000000; // Reset minutes to 00 (000000 in BCD)
        seconds <= 6'b000000; // Reset seconds to 00 (000000 in BCD)
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 6'b010011) begin // 59 in BCD
            seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
            // Increment the minutes counter
            if (minutes == 6'b010011) begin // 59 in BCD
                minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
                // Increment the hours counter
                if (hours == 4'b1001 && pm == 1'b1) begin // 01 PM
                    hours <= 4'b1001; // Reset hours to 01 (1 in BCD)
                    pm <= 1'b0; // Toggle to AM
                end else if (hours == 4'b1001 && pm == 1'b0) begin // 01 AM
                    hours <= 4'b1001; // Reset hours to 01 (1 in BCD)
                    pm <= 1'b1; // Toggle to PM
                end else if (hours == 4'b1000) begin // 12
                    hours <= 4'b1001; // Wrap hours to 01 (1 in BCD)
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
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'b00010001; // Reset hh to 01 (1 in BCD)
        mm <= 8'b00000000; // Reset mm to 00 (0 in BCD)
        ss <= 8'b00000000; // Reset ss to 00 (0 in BCD)
    end else begin
        hh <= {4'b0000, hours}; // Drive hh from hours
        mm <= {2'b00, minutes}; // Drive mm from minutes
        ss <= {2'b00, seconds}; // Drive ss from seconds
    end
end

endmodule