module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;
reg [3:0] minutes;
reg [3:0] hours;
reg pm_reg;

assign pm = pm_reg;
assign hh = {1'b0, hours, 4'b0000};
assign mm = {1'b0, minutes, 4'b0000};
assign ss = {1'b0, seconds, 4'b0000};

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'd0;
        minutes <= 4'd0;
        hours <= 4'd1;  // Initialize hours to 1 for 12-hour clock
        pm_reg <= 1'b0; // Initialize PM indicator to AM
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 4'd59) begin
            seconds <= 4'd0;
            // Increment minutes counter
            if (minutes == 4'd59) begin
                minutes <= 4'd0;
                // Increment hours counter
                if (hours == 4'd12) begin
                    hours <= 4'd1;
                    pm_reg <= ~pm_reg; // Toggle PM indicator
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

endmodule