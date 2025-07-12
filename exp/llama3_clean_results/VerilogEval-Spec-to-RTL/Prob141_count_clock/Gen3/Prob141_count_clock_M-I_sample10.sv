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
reg [3:0] hours; // Hours in 12-hour format (0-11)

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0; // Reset hours to 12 AM (0)
        pm <= 1'b0; // Reset to AM
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
                    pm <= 1'b0; // Reset AM/PM
                end else begin
                    hours <= hours + 1'b1;
                    if (hours == 4'd12) begin // Should not occur but just in case
                        hours <= 4'd0;
                        pm <= 1'b0;
                    end else if (hours == 4'd6) begin // Switch to PM
                        pm <= 1'b1;
                    end else if (hours == 4'd0 && pm == 1'b1) begin // Switch to AM
                        pm <= 1'b0;
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

// Convert internal counters to BCD and output
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // Reset hours to 12
        mm <= 8'd0; // Reset minutes to 0
        ss <= 8'd0; // Reset seconds to 0
    end else begin
        ss <= {2'b0, seconds}; // Convert seconds to BCD
        mm <= {2'b0, minutes}; // Convert minutes to BCD
        
        // Convert hours to BCD, considering 12-hour format
        if (hours == 4'd0) begin
            hh <= 8'd12; // 12 AM/PM
        end else begin
            hh <= {4'b0, hours}; // Directly assign hours to BCD
        end
    end
end

endmodule