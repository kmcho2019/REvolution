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
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
        pm <= 0; // AM
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes counter
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours counter
                if (hours == 11) begin // 11 because hours are 0-11 for 12-hour clock
                    hours <= 0;
                    pm <= ~pm; // Toggle AM/PM
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

// Convert internal counters to BCD for output
always @(*) begin
    ss <= {4'd0, seconds};
    mm <= {4'd0, minutes};
    if (hours < 12) begin
        hh <= {1'b0, hours};
    end else begin
        hh <= {1'b1, hours - 12};
    end
    if (hours >= 12) begin
        pm <= 1'b1; // PM
    end else begin
        pm <= 1'b0; // AM
    end
end

endmodule