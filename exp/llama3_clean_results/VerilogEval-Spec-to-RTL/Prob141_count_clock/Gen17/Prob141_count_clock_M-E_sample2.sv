module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] total_seconds;

always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 0;
        pm <= 1'b0;
        hh <= 8'b00010010; // "12"
        mm <= 8'b00000000; // "00"
        ss <= 8'b00000000; // "00"
    end else if (ena) begin
        total_seconds <= total_seconds + 1;
        
        // Calculate hours, minutes, and seconds
        reg [4:0] hours;
        reg [5:0] minutes;
        reg [5:0] seconds;
        hours <= total_seconds / 3600 % 12;
        minutes <= (total_seconds / 60) % 60;
        seconds <= total_seconds % 60;
        
        // Update am/pm indicator
        if (total_seconds >= 43200) begin
            pm <= 1'b1; // PM
        end else begin
            pm <= 1'b0; // AM
        end
        
        // Convert hours to BCD
        reg [3:0] hours_tens;
        reg [3:0] hours_ones;
        if (hours == 0) begin
            hours_tens = 1;
            hours_ones = 2;
        end else if (hours < 10) begin
            hours_tens = 0;
            hours_ones = hours;
        end else begin
            hours_tens = hours / 10;
            hours_ones = hours % 10;
        end
        
        // Convert minutes and seconds to BCD
        reg [3:0] minutes_tens;
        reg [3:0] minutes_ones;
        reg [3:0] seconds_tens;
        reg [3:0] seconds_ones;
        minutes_tens = minutes / 10;
        minutes_ones = minutes % 10;
        seconds_tens = seconds / 10;
        seconds_ones = seconds % 10;
        
        // Assign BCD values to output registers
        hh <= {hours_tens, hours_ones};
        mm <= {minutes_tens, minutes_ones};
        ss <= {seconds_tens, seconds_ones};
    end
end

endmodule