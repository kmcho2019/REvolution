module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Initialize counters
reg [3:0] seconds_units;
reg [3:0] seconds_tens;
reg [3:0] minutes_units;
reg [3:0] minutes_tens;
reg [3:0] hours_units;
reg [3:0] hours_tens;

always @(posedge clk) begin
    if (reset) begin
        // Reset counters to initial values
        seconds_units <= 0;
        seconds_tens <= 0;
        minutes_units <= 0;
        minutes_tens <= 0;
        hours_units <= 0;
        hours_tens <= 1;
        pm <= 0;
    end else if (ena) begin
        // Increment seconds counter
        if (seconds_units == 9) begin
            seconds_units <= 0;
            if (seconds_tens == 5) begin
                seconds_tens <= 0;
                // Increment minutes counter
                if (minutes_units == 9) begin
                    minutes_units <= 0;
                    if (minutes_tens == 5) begin
                        minutes_tens <= 0;
                        // Increment hours counter
                        if (hours_units == 9) begin
                            hours_units <= 1;
                            if (hours_tens == 1) begin
                                hours_tens <= 1;
                                pm <= ~pm;
                            end else begin
                                hours_tens <= 0;
                            end
                        end else begin
                            hours_units <= hours_units + 1;
                            if (hours_units == 3 && hours_tens == 1) begin
                                hours_tens <= 0;
                                hours_units <= 1;
                                pm <= ~pm;
                            end
                        end
                    end else begin
                        minutes_tens <= minutes_tens + 1;
                    end
                end else begin
                    minutes_units <= minutes_units + 1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1;
            end
        end else begin
            seconds_units <= seconds_units + 1;
        end
    end
end

// Assign BCD counters to output ports
assign hh = {hours_tens, hours_units};
assign mm = {minutes_tens, minutes_units};
assign ss = {seconds_tens, seconds_units};

endmodule