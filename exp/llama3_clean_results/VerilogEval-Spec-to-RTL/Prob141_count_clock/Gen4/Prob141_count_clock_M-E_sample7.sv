module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define the states for the FSM
enum logic [1:0] {AM, PM} state;

// Define the counters for hours, minutes, and seconds
reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

// Define the output signals
assign pm = (state == PM);
assign hh = {4'b0000, hours};
assign mm = {2'b00, minutes[5:4], minutes[3:0]};
assign ss = {2'b00, seconds[5:4], seconds[3:0]};

// Define the FSM
always @ (posedge clk) begin
    if (reset) begin
        // Reset the clock to 12:00 AM
        hours <= 4'b1001;
        minutes <= 6'b000000;
        seconds <= 6'b000000;
        state <= AM;
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 6'b100111) begin
            // Reset the seconds counter and increment the minutes counter
            seconds <= 6'b000000;
            if (minutes == 6'b100111) begin
                // Reset the minutes counter and increment the hours counter
                minutes <= 6'b000000;
                if (hours == 4'b1001 && state == AM) begin
                    // Transition to PM when the hour reaches 12 AM
                    hours <= 4'b0001;
                    state <= PM;
                end else if (hours == 4'b1001 && state == PM) begin
                    // Transition to AM when the hour reaches 12 PM
                    hours <= 4'b0001;
                    state <= AM;
                end else begin
                    // Increment the hours counter
                    hours <= hours + 1'b1;
                end
            end else begin
                // Increment the minutes counter
                minutes <= minutes + 1'b1;
            end
        end else begin
            // Increment the seconds counter
            seconds <= seconds + 1'b1;
        end
    end
end

endmodule