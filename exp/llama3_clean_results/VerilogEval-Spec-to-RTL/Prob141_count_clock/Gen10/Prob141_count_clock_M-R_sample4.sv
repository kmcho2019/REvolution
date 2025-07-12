module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'd12; // 12 in BCD
        minutes <= 8'd0; // 00 in BCD
        seconds <= 8'd0; // 00 in BCD
        pm <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 8'd59) begin
            seconds <= 8'd0;
            if (minutes == 8'd59) begin
                minutes <= 8'd0;
                if (hours == 8'd12) begin
                    hours <= 8'd1; // 1 in BCD
                    pm <= ~pm; // Toggle AM/PM
                end else if (hours == 8'd11) begin // 11 in BCD
                    hours <= 8'd12; // 12 in BCD
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

// No need for assign statements as the outputs are already reg type
// and can be directly assigned in the always block

endmodule