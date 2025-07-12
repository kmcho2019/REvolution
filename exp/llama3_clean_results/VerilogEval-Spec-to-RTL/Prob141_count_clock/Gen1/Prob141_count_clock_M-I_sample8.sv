module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal counters for seconds, minutes, and hours
reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;

// Reset all counters on reset
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0; // Reset seconds to 0
        minutes <= 6'd0; // Reset minutes to 0
        hours <= 5'd0; // Reset hours to 0 (12-hour format, 0 represents 12 AM)
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes counter
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours counter
                if (hours == 5'd11) begin // 11 because hours are 0-11 for 12-hour clock
                    hours <= 5'd0;
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

// Convert internal counters to BCD for output and update pm
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // Reset hours to 12 (AM)
        mm <= 8'd0; // Reset minutes to 0
        ss <= 8'd0; // Reset seconds to 0
        pm <= 1'b0; // Reset to AM
    end else begin
        ss <= {2'b0, seconds}; // Convert seconds to BCD
        mm <= {2'b0, minutes}; // Convert minutes to BCD
        if (hours < 5'd12) begin
            hh <= {4'b0, hours}; // Convert hours to BCD, assuming 0-11 for 12-hour clock
            if (hours >= 5'd6) begin // Adjust for 12-hour format
                pm <= 1'b1; // PM
            end else begin
                pm <= 1'b0; // AM
            end
        end else begin
            // Should not reach here, but for completeness
            hh <= {4'b0, hours - 5'd12}; // Incorrect, this should not happen
        end
    end
end

endmodule