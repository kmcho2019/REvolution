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
        // Reset counters and outputs
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0; // 12 AM
        pm <= 1'b0;
        hh <= 8'd12;
        mm <= 8'd0;
        ss <= 8'd0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours == 4'd11) begin
                    hours <= 4'd0;
                    pm <= 1'b0; // Switch to AM
                end else begin
                    hours <= hours + 1'b1;
                    if (hours == 4'd12) begin
                        pm <= 1'b1; // Switch to PM
                    end
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end

    // Convert internal counters to BCD
    ss <= {2'b0, seconds};
    mm <= {2'b0, minutes};
    if (hours == 4'd0) begin
        hh <= 8'd12;
    end else if (hours < 4'd12) begin
        hh <= {4'b0, hours};
    end else begin
        // This condition is technically not needed given hours is 4 bits
        // But kept for clarity on the wrap-around logic
        hh <= {4'b0, hours - 4'd12};
    end
end

endmodule