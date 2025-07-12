module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours; // Hours in 0-11 format
reg am_pm; // 0: AM, 1: PM
reg [5:0] seconds;
reg [5:0] minutes;

// Lookup table for BCD conversion
reg [7:0] bcd_table [0:59];

initial begin
    for (int i = 0; i <= 59; i++) begin
        bcd_table[i] = (i / 10) * 8'd10 + (i % 10);
    end
end

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0; // Initialize hours to 0 (12 AM)
        am_pm <= 1'b0; // Initialize AM/PM to AM
        seconds <= 6'd0;
        minutes <= 6'd0;
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0; // Roll over to 0 (12 AM)
                    am_pm <= 1'b0; // Switch to AM
                end else if (hours == 4'd11 && am_pm == 1'b1) begin // 11 PM to 12 AM
                    hours <= 4'd0;
                    am_pm <= 1'b0;
                end else if (hours == 4'd5 && am_pm == 1'b0) begin // Noon
                    hours <= 4'd6; // 6 in 0-11 format represents 12 PM
                    am_pm <= 1'b1; // Switch to PM
                end else begin
                    hours <= hours + 1;
                    if (hours == 4'd12) begin
                        hours <= 4'd1; // Wrap around to 1 PM
                        am_pm <= 1'b1; // Switch to PM
                    end
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Assign BCD values to output signals
assign hh = (hours == 4'd0) ? 8'd12 : (hours < 4'd10) ? bcd_table[hours] : {4'd1, hours - 4'd10};
assign mm = bcd_table[minutes];
assign ss = bcd_table[seconds];
assign pm = am_pm;

endmodule