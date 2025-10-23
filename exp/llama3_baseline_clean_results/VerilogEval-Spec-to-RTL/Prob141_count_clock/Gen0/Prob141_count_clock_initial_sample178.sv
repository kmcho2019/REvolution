module TopModule(
    input         clk,
    input         reset,
    input         ena,
    output        pm,
    output [7:0]  hh,
    output [7:0]  mm,
    output [7:0]  ss
);

reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [5:0] minutes_tens;
reg [5:0] minutes_ones;
reg [5:0] seconds_tens;
reg [5:0] seconds_ones;
reg         pm_mode;

// BCD encoding for hours, minutes, and seconds
assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

// Initialize counters and pm mode on reset
always @(posedge clk) begin
    if(reset) begin
        hours_tens <= 4'd1;
        hours_ones <= 4'd2;
        minutes_tens <= 4'd0;
        minutes_ones <= 4'd0;
        seconds_tens <= 4'd0;
        seconds_ones <= 4'd0;
        pm_mode <= 1'b0;
    end
    // Increment counters on enable signal
    else if (ena) begin
        // Increment seconds
        if (seconds_ones == 4'd9) begin
            seconds_ones <= 4'd0;
            if (seconds_tens == 4'd5) begin
                seconds_tens <= 4'd0;
                // Increment minutes
                if (minutes_ones == 4'd9) begin
                    minutes_ones <= 4'd0;
                    if (minutes_tens == 4'd5) begin
                        minutes_tens <= 4'd0;
                        // Increment hours
                        if (hours_ones == 4'd9) begin
                            hours_ones <= 4'd1;
                            if (hours_tens == 4'd1) begin
                                hours_tens <= 4'd0;
                                pm_mode <= ~pm_mode;
                            end
                            else if (hours_tens == 4'd2) begin
                                hours_tens <= 4'd1;
                                hours_ones <= 4'd2;
                            end
                            else begin
                                hours_tens <= hours_tens + 1'd1;
                            end
                        end
                        else begin
                            hours_ones <= hours_ones + 1'd1;
                        end
                    end
                    else begin
                        minutes_tens <= minutes_tens + 1'd1;
                    end
                end
                else begin
                    minutes_ones <= minutes_ones + 1'd1;
                end
            end
            else begin
                seconds_tens <= seconds_tens + 1'd1;
            end
        end
        else begin
            seconds_ones <= seconds_ones + 1'd1;
        end
    end
end

// Assign pm mode
assign pm = pm_mode;

endmodule