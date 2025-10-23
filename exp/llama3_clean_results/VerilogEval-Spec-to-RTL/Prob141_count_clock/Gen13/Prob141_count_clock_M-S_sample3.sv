module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours_12; // 0-11 for 12-hour format
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours_12 <= 0;
        minutes <= 0;
        seconds <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours_12 == 11) begin
                    hours_12 <= 0;
                end else begin
                    hours_12 <= hours_12 + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Convert binary to BCD
function [7:0] binary_to_bcd;
    input [5:0] binary;
    reg [3:0] tens;
    reg [3:0] ones;
    tens = binary / 10;
    ones = binary % 10;
    binary_to_bcd = {4'b0000, tens, ones};
endfunction

// Assign outputs
assign pm = (hours_12 >= 6) ? 1'b1 : 1'b0;
assign hh = (hours_12 == 0) ? {4'b0000, 4'd12} : binary_to_bcd({2'b0, hours_12});
assign mm = binary_to_bcd(minutes);
assign ss = binary_to_bcd(seconds);

endmodule