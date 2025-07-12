module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Define parameters for clock frequency
parameter CLK_FREQ = 100000000; // 100 MHz
parameter SECONDS_PER_MINUTE = 60;

// Define parameters for BCD conversion
parameter MAX_HOURS = 12;
parameter MAX_MINUTES = 60;
parameter MAX_SECONDS = 60;

// High-resolution counter
reg [31:0] counter;

// Synchronized reset signal
reg reset_sync;

// Time values in seconds
reg [31:0] time_seconds;

// BCD values for hours, minutes, and seconds
reg [3:0] hours_bcd;
reg [5:0] minutes_bcd;
reg [5:0] seconds_bcd;

// Convert time to BCD
always @(time_seconds) begin
    // Calculate hours, minutes, and seconds
    reg [5:0] seconds_temp = time_seconds % SECONDS_PER_MINUTE;
    reg [5:0] minutes_temp = (time_seconds / SECONDS_PER_MINUTE) % SECONDS_PER_MINUTE;
    reg [3:0] hours_temp = (time_seconds / (SECONDS_PER_MINUTE * SECONDS_PER_MINUTE)) % MAX_HOURS;

    // Convert to BCD
    hours_bcd = (hours_temp < 10) ? {4'd0, hours_temp} : {4'd1, hours_temp - 10};
    minutes_bcd = (minutes_temp < 10) ? {2'd0, minutes_temp} : {2'd1, minutes_temp - 10};
    seconds_bcd = (seconds_temp < 10) ? {2'd0, seconds_temp} : {2'd1, seconds_temp - 10};
end

// Update output signals
always @(hours_bcd, minutes_bcd, seconds_bcd) begin
    // AM/PM indicator
    pm = (hours_bcd[3:0] >= 4'd6) ? 1'b1 : 1'b0;

    // Output signals
    hh = {2'b0, hours_bcd};
    mm = {2'b0, minutes_bcd};
    ss = {2'b0, seconds_bcd};
end

// Update counter and time values
always @(posedge clk) begin
    if (reset_sync) begin
        counter <= 32'd0;
        time_seconds <= 32'd0;
    end else if (ena) begin
        counter <= counter + 1'b1;

        // Calculate time in seconds
        if (counter == (CLK_FREQ / SECONDS_PER_MINUTE)) begin
            counter <= 32'd0;
            time_seconds <= time_seconds + 1'b1;
        end
    end
end

// Synchronize reset signal
always @(posedge clk) begin
    reset_sync <= reset;
end

endmodule