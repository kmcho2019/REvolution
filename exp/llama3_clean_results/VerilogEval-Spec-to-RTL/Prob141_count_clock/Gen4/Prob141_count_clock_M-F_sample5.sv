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
reg [3:0] hours_12; // Hours in 12-hour format (0-11)

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours_12 <= 4'd0; // Reset hours to 12 AM (0)
        pm <= 1'b0; // Reset to AM
        hh <= 8'd12; // Reset hours to 12 AM/PM in BCD
        mm <= 8'd0; // Reset minutes to 0
        ss <= 8'd0; // Reset seconds to 0
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours_12 == 4'd11) begin
                    hours_12 <= 4'd0; // Wrap around to 12 AM
                    pm <= 1'b1; // Switch to PM
                end else if (hours_12 == 4'd12 - 1) begin
                    hours_12 <= 4'd0; // Correct wrap-around for 12-hour format
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hours_12 <= hours_12 + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
        
        // Convert internal counters to BCD and output
        ss <= {2'b0, seconds}; // Convert seconds to BCD
        mm <= {2'b0, minutes}; // Convert minutes to BCD
        
        // Convert hours to BCD, considering 12-hour format
        if (hours_12 == 4'd0) begin
            hh <= 8'd12; // 12 AM/PM
        end else begin
            hh <= {4'b0, hours_12} + 8'd1; // Adjust hours for BCD (01-12)
        end
    end
end

endmodule