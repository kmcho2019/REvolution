module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Internal registers for hours, minutes, and seconds
reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;

// Initialize the internal registers
initial begin
    hours = 8'h01; // 01 for 12:00 AM
    minutes = 8'h00;
    seconds = 8'h00;
end

// Assign the internal registers to the output ports
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

// Use a bit to track whether it's AM or PM
reg pm_bit;
assign pm = pm_bit;

// Update the internal registers on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        // Reset the clock to 12:00 AM when reset is high
        hours <= 8'h01;
        minutes <= 8'h00;
        seconds <= 8'h00;
        pm_bit <= 1'b0; // AM
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 8'h59) begin
            seconds <= 8'h00;
            // Increment the minutes counter
            if (minutes == 8'h59) begin
                minutes <= 8'h00;
                // Increment the hours counter
                if (hours == 8'h12) begin
                    hours <= 8'h01;
                    pm_bit <= ~pm_bit; // Toggle AM/PM
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

endmodule