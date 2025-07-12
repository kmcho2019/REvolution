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
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds, minutes, and hours
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0;
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

// Convert internal counters to BCD and output
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // Reset hours to 12
        mm <= 8'd0; // Reset minutes to 0
        ss <= 8'd0; // Reset seconds to 0
        pm <= 1'b0; // Reset AM/PM
    end else begin
        // Convert seconds and minutes to BCD
        ss <= {2'b0, seconds};
        mm <= {2'b0, minutes};
        
        // Convert hours to BCD and update AM/PM
        if (hours == 4'd0) begin
            hh <= 8'd12; // 12 AM/PM
            pm <= 1'b0; // AM
        end else if (hours < 4'd12) begin
            hh <= {4'b0, hours}; // Directly assign hours to BCD
            pm <= (hours >= 4'd6) ? 1'b1 : 1'b0; // Update AM/PM
        end else begin
            // This should not occur due to the hours wrap-around logic
            hh <= 8'd12; // Default to 12
            pm <= 1'b0; // Default to AM
        end
    end
end

endmodule