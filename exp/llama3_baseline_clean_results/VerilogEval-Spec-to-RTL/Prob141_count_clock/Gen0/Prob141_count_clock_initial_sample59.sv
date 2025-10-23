module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 8'b00_00;  // Reset seconds to 00
        minutes <= 8'b00_00;   // Reset minutes to 00
        hours <= 8'b00_01;     // Reset hours to 01 (12 AM)
        pm <= 1'b0;             // Reset PM indicator to AM
    end else if (ena) begin
        if (seconds == 8'b00_59) begin  // Check if seconds is 59
            seconds <= 8'b00_00;        // Reset seconds to 00
            if (minutes == 8'b00_59) begin  // Check if minutes is 59
                minutes <= 8'b00_00;     // Reset minutes to 00
                if (hours == 8'b00_12) begin  // Check if hours is 12
                    hours <= 8'b00_01;   // Reset hours to 01 (1 AM)
                    pm <= 1'b1;           // Set PM indicator to PM
                end else if (hours == 8'b00_01) begin  // Check if hours is 1
                    hours <= 8'b00_02;   // Increment hours to 02
                    pm <= 1'b1;           // Set PM indicator to PM
                end else if (hours == 8'b00_11) begin  // Check if hours is 11
                    hours <= 8'b00_12;   // Set hours to 12
                    pm <= 1'b1;           // Set PM indicator to PM
                end else begin
                    hours <= hours + 1;   // Increment hours
                    pm <= 1'b1;           // Set PM indicator to PM
                end
            end else if (minutes == 8'b00_00) begin  // Check if minutes is 00
                minutes <= minutes + 1;   // Increment minutes
                if (hours == 8'b00_12) begin  // Check if hours is 12
                    pm <= 1'b0;           // Set PM indicator to AM
                end else if (hours == 8'b00_11) begin  // Check if hours is 11
                    hours <= 8'b00_12;   // Set hours to 12
                    pm <= 1'b0;           // Set PM indicator to AM
                end
            end else begin
                minutes <= minutes + 1;   // Increment minutes
            end
            if (hours >= 8'b00_12) begin
                pm <= 1'b1;               // Set PM indicator to PM
            end else begin
                pm <= 1'b0;               // Set PM indicator to AM
            end
        end else begin
            seconds <= seconds + 1;       // Increment seconds
        end
    end

    hh <= hours;  // Assign hours to output
    mm <= minutes;  // Assign minutes to output
    ss <= seconds;  // Assign seconds to output
end

endmodule