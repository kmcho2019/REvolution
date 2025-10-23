module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours; // 0-11 for 12-hour clock
reg [5:0] minutes; // 0-59
reg [5:0] seconds; // 0-59

// Initialize counters
always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0; // Set hours to 12 (0 in 4-bit counter)
        minutes <= 6'd0; // Set minutes to 0
        seconds <= 6'd0; // Set seconds to 0
        pm <= 1'b0; // Set pm to 0 (AM)
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd11) begin // 11 corresponds to 12 in 12-hour clock
                    hours <= 4'd1; // Wrap around to 1 (1 in 12-hour clock)
                    pm <= ~pm; // Toggle pm
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

// Output logic using assign
assign hh = (hours == 4'd0) ? 8'd12 : (hours <= 4'd9) ? {4'b0, hours} : {4'b1, hours - 4'd10};
assign mm = {2'b0, minutes};
assign ss = {2'b0, seconds};

endmodule