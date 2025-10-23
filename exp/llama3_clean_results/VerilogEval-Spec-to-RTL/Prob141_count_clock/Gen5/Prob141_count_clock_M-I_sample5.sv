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
        hours <= 4'd12;
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
                if (hours == 4'd12) begin
                    hours <= 4'd1;
                    am_pm <= 1'b1;
                end else if (hours == 4'd11) begin
                    hours <= 4'd12;
                    am_pm <= 1'b0;
                end else begin
                    hours <= hours + 1'b1;
                    if (hours == 4'd12) begin
                        am_pm <= 1'b1;
                    end
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end

    // Output logic
    hh <= (hours == 4'd12) ? 8'd12 : {4'b0, hours};
    mm <= {2'b0, minutes};
    ss <= {2'b0, seconds};
    pm <= am_pm;
end

endmodule