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
        seconds <= 0;
        minutes <= 0;
        hours <= 12; // 12:00:00 AM
        pm <= 0; // AM
    end else if (ena) begin
        seconds <= seconds + 1;
        
        if (seconds == 60) begin
            seconds <= 0;
            minutes <= minutes + 1;
            
            if (minutes == 60) begin
                minutes <= 0;
                hours <= hours + 1;
                
                if (hours == 13) begin
                    hours <= 1; // 1:00:00 AM
                    pm <= 0; // AM
                end else if (hours == 12) begin
                    pm <= 1'b1; // PM
                end else if (hours > 12) begin
                    hours <= hours - 12;
                    pm <= 1'b1; // PM
                end
            end
        end
    end
end

always @(*) begin
    hh = {4'b0, hours};
    mm = {4'b0, minutes};
    ss = {4'b0, seconds};
end

endmodule