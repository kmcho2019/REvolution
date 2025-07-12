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
        pm <= 0; // Reset pm to 0 when reset is high
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 1; // Reset to 1 o'clock after 12
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1;
                    // Update pm based on the new hours value
                    pm <= (hours >= 6 && hours < 12) ? 1'b1 : 1'b0;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

assign hh = (hours == 0)? 8'h12 : (hours < 10)? {4'h1, hours} : {4'h1, hours};
assign mm = (minutes < 10)? {4'h0, minutes} : {4'h1, minutes[3:0]};
assign ss = (seconds < 10)? {4'h0, seconds} : {4'h1, seconds[3:0]};

endmodule