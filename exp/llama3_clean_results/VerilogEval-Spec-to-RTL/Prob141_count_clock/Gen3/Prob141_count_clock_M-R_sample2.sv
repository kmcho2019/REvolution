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
reg pm_state;

localparam RESET_HOURS = 8'h12;
localparam RESET_MINUTES = 8'h00;
localparam RESET_SECONDS = 8'h00;
localparam MAX_HOURS = 8'h12;
localparam MAX_MINUTES = 8'h59;
localparam MAX_SECONDS = 8'h59;

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_state;

always @(posedge clk) begin
    if (reset) begin
        hours <= RESET_HOURS;
        minutes <= RESET_MINUTES;
        seconds <= RESET_SECONDS;
        pm_state <= 1'b0;
    end else if (ena) begin
        if (seconds == MAX_SECONDS) begin
            seconds <= RESET_SECONDS;
            if (minutes == MAX_MINUTES) begin
                minutes <= RESET_MINUTES;
                if (hours == MAX_HOURS) begin
                    hours <= 8'h01;
                    pm_state <= 1'b0;
                end else if (hours == 8'h11) begin
                    hours <= MAX_HOURS;
                    pm_state <= 1'b1;
                end else begin
                    hours <= hours + 8'h01;
                    if (hours == MAX_HOURS) begin
                        pm_state <= 1'b1;
                    end
                end
            end else begin
                minutes <= minutes + 8'h01;
            end
        end else begin
            seconds <= seconds + 8'h01;
        end
    end
end

endmodule