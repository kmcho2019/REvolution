module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours; // 0-11 for 12-hour format
reg [5:0] minutes; // 0-59
reg [5:0] seconds; // 0-59

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0; // Reset hours to 0 (12 AM)
        minutes <= 6'd0; // Reset minutes to 0
        seconds <= 6'd0; // Reset seconds to 0
        pm <= 1'b0; // Reset AM/PM to AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd11) begin // 11 PM
                    hours <= 4'd0; // Wrap around to 12 AM
                    pm <= 1'b0; // Switch to AM
                end else begin
                    hours <= hours + 1'b1;
                    // Switch to PM if transitioning from 11 AM to 12 PM
                    if (hours == 4'd0 && pm == 1'b0) begin
                        pm <= 1'b1;
                    end
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

// Convert to BCD for output
always @(*) begin
    // Hours in BCD (12-hour format)
    if (hours == 4'd0) begin // 12 AM/PM
        hh = {4'd1, 4'd2};
    end else if (hours <= 4'd9) begin // 1-9 AM/PM
        hh = {4'd0, hours};
    end else begin // 10-11 AM/PM
        hh = {4'd1, hours - 4'd10};
    end
    
    // Minutes in BCD
    mm = {minutes[5:4], minutes[3:0]};
    
    // Seconds in BCD
    ss = {seconds[5:4], seconds[3:0]};
end

endmodule