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
reg [3:0] hours;

// Reset all counters and signals on reset
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0;
        pm <= 1'b0;
        hh <= 8'd12;
        mm <= 8'd0;
        ss <= 8'd0;
    end else if (ena) begin
        // Increment seconds counter
        seconds <= (seconds == 6'd59) ? 6'd0 : seconds + 1'b1;

        // Increment minutes counter
        if (seconds == 6'd0) begin
            minutes <= (minutes == 6'd59) ? 6'd0 : minutes + 1'b1;

            // Increment hours counter
            if (minutes == 6'd0) begin
                hours <= (hours == 4'd11) ? 4'd0 : hours + 1'b1;
            end
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

        // Convert hours to BCD, considering 0 represents 12
        if (hours == 4'd0) begin
            hh <= 8'd12;
        end else begin
            hh <= {4'b0, hours};
        end

        // Adjust PM based on hour
        pm <= (hours >= 4'd6 && hours <= 4'd11) ? 1'b1 : 1'b0;
    end
end

endmodule