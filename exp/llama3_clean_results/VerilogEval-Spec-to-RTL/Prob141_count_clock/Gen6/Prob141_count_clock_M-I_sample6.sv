module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0;
        minutes <= 6'd0;
        seconds <= 6'd0;
        am_pm <= 1'b0;
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
                    am_pm <= ~am_pm;
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

always @(posedge clk) begin
    // Output logic
    if (hours == 4'd0) begin
        hh <= 8'd12;
    end else begin
        hh <= {4'b0, hours};
    end
    mm <= {2'b0, minutes};
    ss <= {2'b0, seconds};
    pm <= am_pm;
end

endmodule