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
reg [4:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 0;
                    pm <= 1'b1; // Set to PM after noon
                end else if (hours == 0) begin
                    hours <= 1; // 12 AM
                    pm <= 1'b0; // Set to AM
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

assign hh = (hours == 0) ? 8'h12 : (hours < 10) ? {4'h1, hours} : {4'h1, hours};
assign mm = (minutes < 10) ? {4'h0, minutes} : {4'h1, minutes[3:0]};
assign ss = (seconds < 10) ? {4'h0, seconds} : {4'h1, seconds[3:0]};

endmodule