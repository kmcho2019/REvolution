module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'h12; // reset hours to 12
        minutes <= 8'h00; // reset minutes to 00
        seconds <= 8'h00; // reset seconds to 00
        pm_reg <= 1'b0; // reset pm to AM
    end else if (ena) begin
        // increment seconds
        if (seconds == 8'h59) begin
            seconds <= 8'h00; // reset seconds to 00
            // increment minutes
            if (minutes == 8'h59) begin
                minutes <= 8'h00; // reset minutes to 00
                // increment hours
                if (hours == 8'h12) begin
                    hours <= 8'h01; // reset hours to 01
                    pm_reg <= 1'b0; // set pm to AM
                end else if (hours == 8'h11) begin
                    hours <= 8'h12; // set hours to 12
                    pm_reg <= 1'b1; // set pm to PM
                end else if (hours < 8'h12) begin
                    hours <= hours + 8'h01; // increment hours
                end else begin
                    hours <= hours + 8'h01; // increment hours
                    if (hours == 8'h13) begin
                        hours <= 8'h01; // reset hours to 01
                        pm_reg <= 1'b0; // set pm to AM
                    end
                end
            end else begin
                minutes <= minutes + 8'h01; // increment minutes
            end
        end else begin
            seconds <= seconds + 8'h01; // increment seconds
        end
    end
end

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

endmodule