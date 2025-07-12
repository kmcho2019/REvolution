module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [17:0] counter; // 18-bit counter for seconds, minutes, and hours

always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 0;
    end else if (ena) begin
        if (counter == 43199) begin // 12 hours * 60 minutes * 60 seconds - 1
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Extract seconds, minutes, and hours from the counter
wire [5:0] seconds = counter[5:0];
wire [5:0] minutes = counter[11:6];
wire [4:0] hours = counter[16:12];

// Calculate AM/PM
wire pm_flag = (hours[4])? 1'b1 : 1'b0;

// Calculate BCD for hours, minutes, and seconds
wire [3:0] hours_tens = (hours[3:0] >= 10)? hours[3:0] / 10 : 0;
wire [3:0] hours_ones = (hours[3:0] >= 10)? hours[3:0] % 10 : hours[3:0];
wire [3:0] minutes_tens = (minutes >= 10)? minutes / 10 : 0;
wire [3:0] minutes_ones = (minutes >= 10)? minutes % 10 : minutes;
wire [3:0] seconds_tens = (seconds >= 10)? seconds / 10 : 0;
wire [3:0] seconds_ones = (seconds >= 10)? seconds % 10 : seconds;

// Correctly assign hh, mm, ss considering BCD format
assign pm = pm_flag;
assign hh = {4'b0000, hours_tens, hours_ones};
assign mm = {4'b0000, minutes_tens, minutes_ones};
assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule