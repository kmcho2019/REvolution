module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Internal time representation (seconds since midnight)
    reg [31:0] time_seconds;
    reg pm_state;
    
    // State definitions
    localparam AM = 1'b0;
    localparam PM = 1'b1;
    
    // Constants
    localparam SECONDS_PER_MINUTE = 60;
    localparam SECONDS_PER_HOUR = 3600;
    localparam SECONDS_PER_HALF_DAY = 43200; // 12 hours
    
    // Time update logic
    always @(posedge clk) begin
        if (reset) begin
            time_seconds <= 0;          // 12:00:00 AM (0 seconds)
            pm_state <= AM;
        end else if (ena) begin
            if (time_seconds == SECONDS_PER_HALF_DAY - 1) begin
                // Toggle AM/PM at noon/midnight
                pm_state <= ~pm_state;
                time_seconds <= 0;
            end else begin
                time_seconds <= time_seconds + 1;
            end
        end
    end
    
    // Output conversion (combinational)
    wire [31:0] display_time = (time_seconds < SECONDS_PER_HALF_DAY) ? 
                             time_seconds : time_seconds - SECONDS_PER_HALF_DAY;
    
    // Convert to BCD hours (1-12)
    wire [31:0] hour_seconds = display_time % SECONDS_PER_HALF_DAY;
    wire [4:0] hour_raw = (hour_seconds / SECONDS_PER_HOUR) + 1;
    wire [3:0] hour_lo = (hour_raw > 12) ? hour_raw - 12 : 
                        (hour_raw == 0) ? 12 : hour_raw;
    wire [3:0] hour_hi = (hour_lo >= 10) ? 1 : 0;
    
    // Convert to BCD minutes
    wire [31:0] minute_seconds = display_time % SECONDS_PER_HOUR;
    wire [5:0] minute_raw = minute_seconds / SECONDS_PER_MINUTE;
    wire [3:0] minute_lo = minute_raw % 10;
    wire [3:0] minute_hi = minute_raw / 10;
    
    // Convert to BCD seconds
    wire [5:0] second_raw = display_time % SECONDS_PER_MINUTE;
    wire [3:0] second_lo = second_raw % 10;
    wire [3:0] second_hi = second_raw / 10;
    
    // Output assignments
    assign pm = pm_state;
    assign hh = {hour_hi, hour_lo};
    assign mm = {minute_hi, minute_lo};
    assign ss = {second_hi, second_lo};

endmodule