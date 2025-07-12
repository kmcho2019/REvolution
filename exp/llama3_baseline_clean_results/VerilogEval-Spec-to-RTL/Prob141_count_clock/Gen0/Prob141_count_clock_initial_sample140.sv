module TopModule(
    input clk, 
    input reset, 
    input ena, 
    output pm, 
    output [7:0] hh, 
    output [7:0] mm, 
    output [7:0] ss
);

// counters for hours, minutes, and seconds
reg [3:0] hour_tens;
reg [3:0] hour_ones;
reg [3:0] min_tens;
reg [3:0] min_ones;
reg [3:0] sec_tens;
reg [3:0] sec_ones;

// pm indicator
reg pm_ind;

// internal wires
reg [3:0] hour_temp;
reg [3:0] min_temp;
reg [3:0] sec_temp;

// assign output signals
assign hh = {hour_tens, hour_ones};
assign mm = {min_tens, min_ones};
assign ss = {sec_tens, sec_ones};
assign pm = pm_ind;

// sequential logic
always @(posedge clk) begin
    if (reset) begin
        // reset counters and pm indicator
        hour_tens <= 0;
        hour_ones <= 1; // initialize to 01 for 12 AM
        min_tens <= 0;
        min_ones <= 0;
        sec_tens <= 0;
        sec_ones <= 0;
        pm_ind <= 0;
    end else if (ena) begin
        // increment seconds counter
        if (sec_ones == 9 && sec_tens == 5) begin
            // reset seconds counter and increment minutes counter
            sec_tens <= 0;
            sec_ones <= 0;
            if (min_ones == 9 && min_tens == 5) begin
                // reset minutes counter and increment hours counter
                min_tens <= 0;
                min_ones <= 0;
                if (hour_ones == 2 && hour_tens == 1) begin
                    // wrap around to 12 AM
                    hour_tens <= 0;
                    hour_ones <= 1;
                    pm_ind <= 0;
                end else if (hour_ones == 2 && hour_tens == 0) begin
                    // wrap around to 1 PM
                    hour_tens <= 0;
                    hour_ones <= 1;
                    pm_ind <= 1;
                end else if (hour_ones == 9 && hour_tens == 1) begin
                    // wrap around to 12 PM
                    hour_tens <= 0;
                    hour_ones <= 0;
                    pm_ind <= 1;
                end else begin
                    // increment hours counter
                    if (hour_ones == 9) begin
                        hour_tens <= hour_tens + 1;
                        hour_ones <= 0;
                    end else begin
                        hour_ones <= hour_ones + 1;
                    end
                    // update pm indicator
                    if (hour_tens == 1 && hour_ones == 2) begin
                        pm_ind <= 1;
                    end else if (hour_tens == 0 && hour_ones == 0) begin
                        pm_ind <= 0;
                    end
                end
            end else if (min_ones == 9) begin
                // increment minutes counter tens place
                min_tens <= min_tens + 1;
                min_ones <= 0;
            end else begin
                // increment minutes counter ones place
                min_ones <= min_ones + 1;
            end
        end else if (sec_tens == 5) begin
            // increment seconds counter tens place
            sec_tens <= 0;
            sec_ones <= sec_ones + 1;
        end else begin
            // increment seconds counter ones place
            sec_ones <= sec_ones + 1;
        end
    end
end

endmodule