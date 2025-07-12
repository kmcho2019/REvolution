module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;
reg pm_reg;

assign pm = pm_reg;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

always @(posedge clk) begin
    if (reset) begin
        // Reset all counters and pm indicator
        hours <= 8'h12;  // Binary-coded decimal for 12
        minutes <= 8'h00;
        seconds <= 8'h00;
        pm_reg <= 1'b0;  // AM
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 8'h59) begin
            seconds <= 8'h00;
            // Increment minutes counter
            if (minutes == 8'h59) begin
                minutes <= 8'h00;
                // Increment hours counter
                if (hours == 8'h12) begin
                    hours <= 8'h01;  // Binary-coded decimal for 1
                    pm_reg <= ~pm_reg;  // Toggle AM/PM
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