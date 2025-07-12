module TopModule (
    input         clk,
    input         reset,
    input         ena,
    output        pm,
    output [7:0]  hh,
    output [7:0]  mm,
    output [7:0]  ss
);

// Define the internal signals
reg [5:0] sec;
reg [5:0] min;
reg [3:0] hour;
reg        is_pm;

// Define the initial values
initial begin
    sec = 0;
    min = 0;
    hour = 1;
    is_pm = 0;
end

// Define the always block
always @(posedge clk) begin
    // Reset the clock
    if (reset) begin
        sec <= 0;
        min <= 0;
        hour <= 1;
        is_pm <= 0;
    end else if (ena) begin
        // Increment the seconds counter
        if (sec == 59) begin
            sec <= 0;
            // Increment the minutes counter
            if (min == 59) begin
                min <= 0;
                // Increment the hours counter
                if (hour == 12) begin
                    hour <= 1;
                    is_pm <= ~is_pm;
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                min <= min + 1;
            end
        end else begin
            sec <= sec + 1;
        end
    end
end

// Assign the output signals
assign pm = is_pm;
assign hh = {hour[3], hour[3], hour[2], hour[1], hour[0], 1'b0, 1'b0, 1'b0};
assign mm = {min[5], min[5], min[4], min[3], min[2], min[1], min[0], 1'b0};
assign ss = {sec[5], sec[5], sec[4], sec[3], sec[2], sec[1], sec[0], 1'b0};

endmodule