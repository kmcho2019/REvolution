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
        hours <= 1;  // Initialize hours to 1 for 12:00 AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 1;  // Reset hours to 1 when it reaches 12
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

assign pm = (hours >= 6 && hours <= 11)? 1'b1 : 1'b0;  // Generate pm signal based on hour value
assign hh = (hours == 0)? 8'h12 : (hours == 1)? 8'h01 : (hours == 2)? 8'h02 : (hours == 3)? 8'h03 : 
            (hours == 4)? 8'h04 : (hours == 5)? 8'h05 : (hours == 6)? 8'h06 : (hours == 7)? 8'h07 : 
            (hours == 8)? 8'h08 : (hours == 9)? 8'h09 : (hours == 10)? 8'h10 : (hours == 11)? 8'h11 : 8'h12;  // Convert hours to BCD format
assign mm = (minutes < 10)? {4'h0, minutes} : {4'h1, minutes[3:0]};  // Convert minutes to BCD format
assign ss = (seconds < 10)? {4'h0, seconds} : {4'h1, seconds[3:0]};  // Convert seconds to BCD format

endmodule