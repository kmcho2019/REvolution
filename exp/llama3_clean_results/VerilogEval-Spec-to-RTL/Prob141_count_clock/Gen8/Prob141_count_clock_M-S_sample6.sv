module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'b1000; // 12 in BCD
        minutes <= 6'b000000; // 00 in BCD
        seconds <= 6'b000000; // 00 in BCD
        pm <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'b000000;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'b000000;
                // Increment hours
                if (hours == 4'd12) begin
                    hours <= 4'b0001;
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

assign hh = {hours, 4'b0000};
assign mm = {minutes, 2'b00};
assign ss = {seconds, 2'b00};

endmodule