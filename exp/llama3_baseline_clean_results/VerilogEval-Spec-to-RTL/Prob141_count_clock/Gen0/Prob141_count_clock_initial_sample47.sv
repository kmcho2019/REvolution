module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Internal signals
reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [5:0] minutes_tens;
reg [5:0] minutes_ones;
reg [5:0] seconds_tens;
reg [5:0] seconds_ones;

// Initialize output ports
assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

// Initialize pm signal
assign pm = (hours_tens == 4'b0001 && hours_ones >= 4'b0001) || 
            (hours_tens == 4'b0010);

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 4'b0001;
        hours_ones <= 4'b0000;
        minutes_tens <= 4'b0000;
        minutes_ones <= 4'b0000;
        seconds_tens <= 4'b0000;
        seconds_ones <= 4'b0000;
    end else if (ena) begin
        // Increment seconds counter
        if (seconds_ones == 4'b0101) begin
            seconds_ones <= 4'b0000;
            if (seconds_tens == 4'b0101) begin
                seconds_tens <= 4'b0000;
                // Increment minutes counter
                if (minutes_ones == 4'b0101) begin
                    minutes_ones <= 4'b0000;
                    if (minutes_tens == 4'b0101) begin
                        minutes_tens <= 4'b0000;
                        // Increment hours counter
                        if (hours_ones == 4'b0100) begin
                            hours_ones <= 4'b0001;
                            if (hours_tens == 4'b0001) begin
                                hours_tens <= 4'b0000;
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