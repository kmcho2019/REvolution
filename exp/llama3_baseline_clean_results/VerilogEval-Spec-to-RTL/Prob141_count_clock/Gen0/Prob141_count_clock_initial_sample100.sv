module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define the counters for hours, minutes, and seconds
reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;

// Initialize the counters
initial begin
    hours = 8'h12; // 12 in BCD
    minutes = 8'h00;
    seconds = 8'h00;
end

// Define the logic for the counters
always @(posedge clk) begin
    if (reset) begin
        // Reset the counters to 12:00 AM
        hours = 8'h12;
        minutes = 8'h00;
        seconds = 8'h00;
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 8'h59) begin
            seconds = 8'h00;
            // Increment the minutes counter
            if (minutes == 8'h59) begin
                minutes = 8'h00;
                // Increment the hours counter
                if (hours == 8'h12) begin
                    hours = 8'h01;
                end else begin
                    hours = hours + 1;
                end
            end else begin
                minutes = minutes + 1;
            end
        end else begin
            seconds = seconds + 1;
        end
    end
end

// Define the output logic
assign pm = (hours[3]);
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule