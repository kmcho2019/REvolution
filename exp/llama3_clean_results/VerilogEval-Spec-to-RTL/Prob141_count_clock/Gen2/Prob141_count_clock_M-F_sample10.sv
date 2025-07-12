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

// Reset all counters and signals on reset
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0; // Reset seconds to 0
        minutes <= 6'd0; // Reset minutes to 0
        hours <= 5'd0; // Reset hours to 0 (12 AM)
        pm <= 1'b0; // Reset to AM
        hh <= 8'd12; // Display 12 for hours
        mm <= 8'd0; // Reset minutes display to 0
        ss <= 8'd0; // Reset seconds display to 0
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

// Update output signals
always @(posedge clk) begin
    if (reset) begin
        // Already handled in the previous block
    end else begin
        ss <= {2'b0, seconds}; // Convert seconds to BCD
        mm <= {2'b0, minutes}; // Convert minutes to BCD
        if (hours < 5'd12) begin
            hh <= (hours == 5'd0)? 8'd12 : {4'b0, hours}; // Convert hours to BCD, 0 represents 12
            pm <= (hours >= 5'd6)? 1'b1 : 1'b0; // Adjust PM based on hour
        end
    end
end

endmodule