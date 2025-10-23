module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [4:0] hours_24;
reg [5:0] minutes;
reg [5:0] seconds;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        hours_24 <= 0;
        minutes <= 0;
        seconds <= 0;
        pm_flag <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours_24 == 23) begin
                    hours_24 <= 0;
                end else begin
                    hours_24 <= hours_24 + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        pm_flag <= 0;
    end else begin
        pm_flag <= (hours_24 >= 12) ? 1 : 0;
    end
end

// Convert binary to BCD
function [7:0] binary_to_bcd;
    input [5:0] binary;
    reg [3:0] tens;
    reg [3:0] ones;
    reg [7:0] bcd;
    tens = binary / 10;
    ones = binary % 10;
    bcd = {4'b0000, tens, ones};
    binary_to_bcd = bcd;
endfunction

// Assign outputs
assign pm = pm_flag;
assign hh = (hours_24 > 12) ? binary_to_bcd(hours_24 - 12) : (hours_24 == 0) ? binary_to_bcd(12) : binary_to_bcd(hours_24);
assign mm = binary_to_bcd(minutes);
assign ss = binary_to_bcd(seconds);

endmodule