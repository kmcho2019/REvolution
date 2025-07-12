module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] sec_cnt; // internal counter for seconds
reg [5:0] min_cnt; // internal counter for minutes
reg [3:0] hour_cnt; // internal counter for hours

always @(posedge clk) begin
    if (reset) begin
        // reset counters to initial values
        sec_cnt <= 0;
        min_cnt <= 0;
        hour_cnt <= 1; // 12 in BCD
    end else if (ena) begin
        // increment seconds counter
        if (sec_cnt == 59) begin
            sec_cnt <= 0;
            // increment minutes counter
            if (min_cnt == 59) begin
                min_cnt <= 0;
                // increment hours counter
                if (hour_cnt == 12) begin
                    hour_cnt <= 1; // wrap around to 1 (12 in BCD)
                end else begin
                    hour_cnt <= hour_cnt + 1;
                end
            end else begin
                min_cnt <= min_cnt + 1;
            end
        end else begin
            sec_cnt <= sec_cnt + 1;
        end
    end
end

always @(*) begin
    // assign output values
    ss <= {4'b0, sec_cnt};
    mm <= {4'b0, min_cnt};
    hh <= {4'b0, hour_cnt};
    
    // determine AM/PM
    if ((hour_cnt == 12) || (hour_cnt >= 1 && hour_cnt <= 11)) begin
        pm <= (hour_cnt >= 7 && hour_cnt <= 12); // PM if 7-12
    end else begin
        pm <= 0; // default to AM
    end
end

endmodule