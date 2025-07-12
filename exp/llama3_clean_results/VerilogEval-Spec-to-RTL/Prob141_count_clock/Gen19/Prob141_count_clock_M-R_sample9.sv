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
    reg pm_state; // AM/PM state (0 for AM, 1 for PM)

    always @(posedge clk) begin
        if (reset) begin
            hours <= 12; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
            pm_state <= 0; // Reset AM/PM state to AM
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1; // Wrap around from 12 to 1
                        pm_state <= 0; // Update AM/PM state
                    end else if (hours == 11) begin
                        hours <= 12; // Wrap around from 11 to 12
                        pm_state <= 1; // Update AM/PM state
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

    // Derive the 'pm' output directly from the pm_state variable
    assign pm = pm_state;

    // Convert counters to BCD format
    wire [3:0] bcd_hours = hours;
    wire [5:0] bcd_minutes = minutes;
    wire [5:0] bcd_seconds = seconds;

    assign hh = {4'b0000, bcd_hours};
    assign mm = {4'b0000, bcd_minutes[4:0]};
    assign ss = {4'b0000, bcd_seconds[4:0]};

endmodule