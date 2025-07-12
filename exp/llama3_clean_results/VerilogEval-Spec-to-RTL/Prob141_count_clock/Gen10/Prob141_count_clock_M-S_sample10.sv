module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] total_seconds;

always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 0;
    end else if (ena) begin
        total_seconds <= total_seconds + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0; // AM
        hh <= 8'd12; // 12
        mm <= 8'd0; // 0
        ss <= 8'd0; // 0
    end else begin
        // Calculate hours, minutes, and seconds
        reg [4:0] hours;
        reg [5:0] minutes;
        reg [5:0] seconds;
        hours = total_seconds / 3600;
        minutes = (total_seconds % 3600) / 60;
        seconds = total_seconds % 60;
        
        // Adjust hours for 12-hour clock
        if (hours > 12) begin
            pm <= 1'b1; // PM
            hours <= hours - 12;
        end else if (hours == 0) begin
            pm <= 1'b0; // AM
            hours <= 12;
        end else begin
            pm <= hours < 12 ? 1'b0 : 1'b1; // AM/PM
        end
        
        // Convert to BCD
        reg [3:0] hours_tens;
        reg [3:0] hours_ones;
        reg [3:0] minutes_tens;
        reg [3:0] minutes_ones;
        reg [3:0] seconds_tens;
        reg [3:0] seconds_ones;
        hours_tens = hours / 10;
        hours_ones = hours % 10;
        minutes_tens = minutes / 10;
        minutes_ones = minutes % 10;
        seconds_tens = seconds / 10;
        seconds_ones = seconds % 10;
        
        // Assign outputs
        hh <= {hours_tens, hours_ones};
        mm <= {minutes_tens, minutes_ones};
        ss <= {seconds_tens, seconds_ones};
    end
end

endmodule