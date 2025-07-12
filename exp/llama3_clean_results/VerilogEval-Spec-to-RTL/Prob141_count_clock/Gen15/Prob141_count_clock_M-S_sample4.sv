module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 0;
        minutes <= 0;
        seconds <= 0;
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        seconds <= seconds + 1;
        if (seconds == 60) begin
            seconds <= 0;
            minutes <= minutes + 1;
            if (minutes == 60) begin
                minutes <= 0;
                hours <= hours + 1;
                if (hours == 12) begin
                    hours <= 0;
                end
                if (hours >= 12) begin
                    pm <= 1'b1; // PM
                end else begin
                    pm <= 1'b0; // AM
                end
            end
        end
    end
end

always @(posedge clk) begin
    if (hours == 0) begin
        hh <= 8'b0001_0010; // 12 in BCD
    end else begin
        hh <= {hours / 10, hours % 10};
    end
    mm <= {minutes / 10, minutes % 10};
    ss <= {seconds / 10, seconds % 10};
end

endmodule