module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal counters
reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

// Reset logic
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd1; // Reset hours to 1 (12 AM)
        pm <= 1'b0; // Reset AM/PM indicator to AM
    end
end

// Counter update logic
always @(posedge clk) begin
    if (!reset && ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd12) begin
                    hours <= 4'd1; // Wrap around to 12 AM
                    pm <= 1'b0; // Set AM/PM indicator to AM
                end else if (hours == 4'd11) begin
                    hours <= 4'd12; // Wrap around to 12 PM
                    pm <= 1'b1; // Set AM/PM indicator to PM
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

// Output conversion logic
assign hh = (hours == 4'd0)? 8'd12 : (hours == 4'd12)? 8'd12 : {4'd0, hours}; // Convert hours to BCD
assign mm = {4'd0, minutes[5:4], 4'd0, minutes[3:0]}; // Convert minutes to BCD
assign ss = {4'd0, seconds[5:4], 4'd0, seconds[3:0]}; // Convert seconds to BCD

endmodule