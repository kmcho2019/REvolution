module TopModule(
    input           clk,
    input           reset,
    input           ena,
    output          pm,
    output  [7:0]   hh,
    output  [7:0]   mm,
    output  [7:0]   ss
);

reg [3:0]   seconds;
reg [3:0]   minutes;
reg [3:0]   hours;

// Initialize counters
initial begin
    seconds = 0;
    minutes = 0;
    hours = 1; // Start at 12:00 AM
end

// Update counters
always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 1; // Reset to 12:00 AM
    end else if (ena) begin
        if (seconds == 9'd59) begin
            seconds <= 0;
            if (minutes == 9'd59) begin
                minutes <= 0;
                if (hours == 9'd12) begin
                    hours <= 1;
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

// Generate output signals
assign pm = (hours >= 7);
assign hh = {hours[3], hours[2:1]};
assign mm = {minutes[3], minutes[2:1]};
assign ss = {seconds[3], seconds[2:1]};

endmodule