module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal signals
reg [3:0] sec_low;
reg [3:0] sec_high;
reg [3:0] min_low;
reg [3:0] min_high;
reg [3:0] hour_low;
reg [3:0] hour_high;

// Initialize counters
initial begin
    sec_low = 4'b0;
    sec_high = 4'b0;
    min_low = 4'b0;
    min_high = 4'b0;
    hour_low = 4'b0;
    hour_high = 4'b1;
    pm = 1'b0;
end

// Increment counters on positive edge of clk when ena is asserted
always @(posedge clk) begin
    if (reset) begin // Reset counters
        sec_low = 4'b0;
        sec_high = 4'b0;
        min_low = 4'b0;
        min_high = 4'b0;
        hour_low = 4'b0;
        hour_high = 4'b1;
        pm = 1'b0;
    end else if (ena) begin // Increment counters
        // Seconds counter
        if (sec_high == 4'b5 && sec_low == 4'b9) begin
            sec_low = 4'b0;
            sec_high = 4'b0;
            // Minutes counter
            if (min_high == 4'b5 && min_low == 4'b9) begin
                min_low = 4'b0;
                min_high = 4'b0;
                // Hours counter
                if (hour_high == 4'b1 && hour_low == 4'b2) begin
                    hour_low = 4'b1;
                    hour_high = 4'b0;
                    pm = 1'b0;
                end else if (hour_high == 4'b0 && hour_low == 4'b0) begin
                    hour_low = 4'b1;
                    hour_high = 4'b0;
                    pm = 1'b1;
                end else begin
                    hour_low = hour_low + 1'b1;
                    if (hour_low == 4'b0) begin
                        hour_high = hour_high + 1'b1;
                    end
                    if (hour_high == 4'b1 && hour_low == 4'b3) begin
                        pm = 1'b1;
                    end else if (hour_high == 4'b0 && hour_low == 4'b1) begin
                        pm = 1'b0;
                    end
                end
            end else if (min_high == 4'b5 && min_low == 4'b9) begin
                min_low = 4'b0;
                min_high = 4'b0;
                // Hours counter
                if (hour_high == 4'b1 && hour_low == 4'b2) begin
                    hour_low = 4'b1;
                    hour_high = 4'b0;
                    pm = 1'b0;
                end else if (hour_high == 4'b0 && hour_low == 4'b0) begin
                    hour_low = 4'b1;
                    hour_high = 4'b0;
                    pm = 1'b1;
                end else begin
                    hour_low = hour_low + 1'b1;
                    if (hour_low == 4'b0) begin
                        hour_high = hour_high + 1'b1;
                    end
                    if (hour_high == 4'b1 && hour_low == 4'b3) begin
                        pm = 1'b1;
                    end else if (hour_high == 4'b0 && hour_low == 4'b1) begin
                        pm = 1'b0;
                    end
                end
            end else begin
                min_low = min_low + 1'b1;
                if (min_low == 4'b0) begin
                    min_high = min_high + 1'b1;
                end
            end
        end else begin
            sec_low = sec_low + 1'b1;
            if (sec_low == 4'b0) begin
                sec_high = sec_high + 1'b1;
            end
        end
    end
end

// Assign output signals
assign hh = {hour_high, hour_low};
assign mm = {min_high, min_low};
assign ss = {sec_high, sec_low};

endmodule