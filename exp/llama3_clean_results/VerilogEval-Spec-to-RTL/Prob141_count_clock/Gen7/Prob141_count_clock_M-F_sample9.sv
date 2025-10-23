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
reg [3:0] hours; // 4 bits to handle hours 0-12

// State machine for seconds, minutes, and hours
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0; // Reset hours to 0 (12 AM)
        pm <= 1'b0; // Reset AM/PM indicator to AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd11) begin
                    hours <= 4'd0; // Wrap around to 12 AM
                    pm <= 1'b0; // Set AM/PM indicator to AM
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

// Update AM/PM indicator
always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0; // Reset AM/PM indicator to AM
    end else if (ena) begin
        if (hours >= 4'd12) begin
            pm <= 1'b1; // Set AM/PM indicator to PM
        end else begin
            pm <= 1'b0; // Set AM/PM indicator to AM
        end
    end
end

// Output conversion logic
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // Reset hours to 12
        mm <= 8'd0; // Reset minutes to 00
        ss <= 8'd0; // Reset seconds to 00
    end else begin
        // Convert hours to BCD
        if (hours == 4'd0) begin
            hh <= 8'd12; // 12 AM/PM
        end else begin
            hh <= {4'd0, hours}; // Directly assign hours to BCD
        end
        
        // Convert minutes to BCD
        mm <= {4'd0, minutes[5:4]} * 8'd10 + {4'd0, minutes[3:0]}; // Convert minutes to BCD
        
        // Convert seconds to BCD
        ss <= {4'd0, seconds[5:4]} * 8'd10 + {4'd0, seconds[3:0]}; // Convert seconds to BCD
    end
end

endmodule