module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] sec;
reg [3:0] min;
reg [3:0] hour;

always @(posedge clk) begin
    if (reset) begin
        // Reset counters to initial values
        sec <= 4'b0000;
        min <= 4'b0000;
        hour <= 4'b0001; // 12:00 AM
    end else if (ena) begin
        // Increment seconds counter
        if (sec == 4'b1001) begin
            sec <= 4'b0000;
            // Increment minutes counter
            if (min == 4'b1001) begin
                min <= 4'b0000;
                // Increment hours counter
                if (hour == 4'b1100) begin
                    hour <= 4'b0001; // 12:00 AM
                end else if (hour == 4'b1000) begin
                    hour <= 4'b0001; // 12:00 PM
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                min <= min + 1;
            end
        end else begin
            sec <= sec + 1;
        end
    end
end

always @(*) begin
    // Convert internal counters to BCD output
    ss <= {4'b0000, sec};
    mm <= {4'b0000, min};
    hh <= {4'b0000, hour};
    
    // Determine pm/am indicator
    if (hour >= 4'b1000 && hour < 4'b1100) begin
        pm <= 1'b1; // PM
    end else begin
        pm <= 1'b0; // AM
    end
end

endmodule