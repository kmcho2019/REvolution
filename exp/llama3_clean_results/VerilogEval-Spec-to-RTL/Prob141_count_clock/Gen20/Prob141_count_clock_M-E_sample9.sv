module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0; // Reset to 12:00 AM
        pm <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 12) begin
                    hours <= 1; // Wrap around to 1 (1:00 AM)
                    pm <= 1'b0; // AM
                end else if (hours == 11) begin
                    hours <= 12; // Switch to PM
                    pm <= 1'b1; // PM
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

always @(posedge clk) begin
    // Update pm signal based on hours
    if (hours >= 12) begin
        pm <= 1'b1; // PM
    end else begin
        pm <= 1'b0; // AM
    end

    // Convert hours, minutes, and seconds to BCD
    hh <= {4'd1, hours % 10}; // Ensure hours are always in BCD format
    mm <= {(minutes / 10), (minutes % 10)}; // Minutes in BCD
    ss <= {(seconds / 10), (seconds % 10)}; // Seconds in BCD
end

endmodule