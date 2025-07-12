module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define the internal signals
reg [3:0] sec_lo;
reg [3:0] sec_hi;
reg [3:0] min_lo;
reg [3:0] min_hi;
reg [3:0] hour_lo;
reg [3:0] hour_hi;
reg pm_int;

// Implement the seconds counter
always @(posedge clk) begin
    if (reset) begin
        sec_lo <= 0;
        sec_hi <= 0;
    end else if (ena) begin
        if (sec_lo == 9) begin
            sec_lo <= 0;
            if (sec_hi == 5) begin
                sec_hi <= 0;
            end else begin
                sec_hi <= sec_hi + 1;
            end
        end else begin
            sec_lo <= sec_lo + 1;
        end
    end
end

// Implement the minutes counter
always @(posedge clk) begin
    if (reset) begin
        min_lo <= 0;
        min_hi <= 0;
    end else if (ena && sec_lo == 0 && sec_hi == 0) begin
        if (min_lo == 9) begin
            min_lo <= 0;
            if (min_hi == 5) begin
                min_hi <= 0;
            end else begin
                min_hi <= min_hi + 1;
            end
        end else begin
            min_lo <= min_lo + 1;
        end
    end
end

// Implement the hours counter
always @(posedge clk) begin
    if (reset) begin
        hour_lo <= 0;
        hour_hi <= 1;
        pm_int <= 0;
    end else if (ena && sec_lo == 0 && sec_hi == 0 && min_lo == 0 && min_hi == 0) begin
        if (hour_lo == 9 && hour_hi == 1) begin
            hour_lo <= 0;
            hour_hi <= 1;
            pm_int <= ~pm_int;
        end else if (hour_lo == 2 && hour_hi == 1) begin
            hour_lo <= 0;
            hour_hi <= 1;
        end else if (hour_lo == 9) begin
            hour_lo <= 0;
            hour_hi <= hour_hi + 1;
        end else begin
            hour_lo <= hour_lo + 1;
        end
    end
end

// Assign the internal signals to the output ports
assign pm = pm_int;
assign hh = {hour_hi, hour_lo};
assign mm = {min_hi, min_lo};
assign ss = {sec_hi, sec_lo};

endmodule