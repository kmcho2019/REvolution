module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
        pm <= 1'b0; // Reset to AM
        hh <= 8'b00010010; // Reset to 12 hours
        mm <= 8'b00000000; // Reset to 00 minutes
        ss <= 8'b00000000; // Reset to 00 seconds
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 0;
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end

        // Determine pm signal
        if (hours >= 6) begin
            pm <= 1'b1; // PM
        end else begin
            pm <= 1'b0; // AM
        end

        // Convert hours, minutes, and seconds to BCD
        hh <= {4'b0000 + hours / 10, 4'b0000 + hours % 10};
        mm <= {4'b0000 + minutes / 10, 4'b0000 + minutes % 10};
        ss <= {4'b0000 + seconds / 10, 4'b0000 + seconds % 10};
    end
end

endmodule