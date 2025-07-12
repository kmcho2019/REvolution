module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Initialize registers to store hours, minutes, and seconds
reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [3:0] minutes_tens;
reg [3:0] minutes_ones;
reg [3:0] seconds_tens;
reg [3:0] seconds_ones;

// Initialize 'pm' register
reg pm_reg;

// Assign output ports
assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};
assign pm = pm_reg;

// Initialize counters to 12:00 AM
initial begin
    hours_tens = 4'h1;
    hours_ones = 4'h2;
    minutes_tens = 4'h0;
    minutes_ones = 4'h0;
    seconds_tens = 4'h0;
    seconds_ones = 4'h0;
    pm_reg = 1'b0;
end

// Increment counters when 'ena' is asserted
always @(posedge clk) begin
    if (reset) begin
        // Reset counters to 12:00 AM when 'reset' is asserted
        hours_tens <= 4'h1;
        hours_ones <= 4'h2;
        minutes_tens <= 4'h0;
        minutes_ones <= 4'h0;
        seconds_tens <= 4'h0;
        seconds_ones <= 4'h0;
        pm_reg <= 1'b0;
    end else if (ena) begin
        // Increment seconds counter
        if (seconds_ones == 4'h9) begin
            seconds_ones <= 4'h0;
            if (seconds_tens == 4'h5) begin
                seconds_tens <= 4'h0;
                // Increment minutes counter
                if (minutes_ones == 4'h9) begin
                    minutes_ones <= 4'h0;
                    if (minutes_tens == 4'h5) begin
                        minutes_tens <= 4'h0;
                        // Increment hours counter
                        if (hours_ones == 4'h9) begin
                            hours_ones <= 4'h0;
                            if (hours_tens == 4'h1) begin
                                hours_tens <= 4'h0;
                                hours_ones <= 4'h1;
                                pm_reg <= ~pm_reg;
                            end else begin
                                hours_tens <= hours_tens + 1;
                            end
                        end else begin
                            hours_ones <= hours_ones + 1;
                        end
                    end else begin
                        minutes_tens <= minutes_tens + 1;
                    end
                end else begin
                    minutes_ones <= minutes_ones + 1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1;
            end
        end else begin
            seconds_ones <= seconds_ones + 1;
        end
    end
end

endmodule