module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] sec;  // seconds counter
reg [5:0] min;  // minutes counter
reg [3:0] hour; // hours counter

always @(posedge clk) begin
    if (reset) begin // reset the clock
        sec <= 0;
        min <= 0;
        hour <= 0;
        pm <= 0; // AM
    end else if (ena) begin // increment the clock
        if (sec == 59) begin // increment minutes
            sec <= 0;
            if (min == 59) begin // increment hours
                min <= 0;
                if (hour == 11) begin // wrap around to 12 AM
                    hour <= 0;
                    pm <= 0; // AM
                end else if (hour == 12) begin // wrap around to 1 PM
                    hour <= 1;
                    pm <= 1; // PM
                end else if (hour == 12 - 1) begin // wrap around to 12 PM
                    hour <= 12;
                    pm <= 1; // PM
                end else if (hour < 12) begin // increment hours (AM)
                    hour <= hour + 1;
                end else begin // increment hours (PM)
                    hour <= hour + 1;
                end
            end else begin // increment minutes
                min <= min + 1;
            end
        end else begin // increment seconds
            sec <= sec + 1;
        end
    end
end

always @(posedge clk) begin
    // convert counters to BCD format
    hh <= {4'd1, hour[3:0]};
    if (min < 6) begin
        mm <= {4'd0, min[5:0]};
    end else begin
        mm <= {4'd1, min[5:0] - 6};
    end
    if (sec < 6) begin
        ss <= {4'd0, sec[5:0]};
    end else begin
        ss <= {4'd1, sec[5:0] - 6};
    end
    // set pm output
    if (hour >= 12) begin
        pm <= 1; // PM
    end else begin
        pm <= 0; // AM
    end
end

endmodule