module TopModule(
    input         clk,     // clock signal
    input         reset,   // active high synchronous reset signal
    input         ena,     // enable signal (once per second)
    output        pm,      // pm signal (1 for PM, 0 for AM)
    output  [7:0] hh,      // hours (BCD, 2 digits)
    output  [7:0] mm,      // minutes (BCD, 2 digits)
    output  [7:0] ss       // seconds (BCD, 2 digits)
);

reg [7:0] hour, minute, second;
reg        pm_state;

// Initialize counters to 12:00 AM
initial begin
    hour   = 8'h12;  // 12 in BCD
    minute = 8'h00; // 00 in BCD
    second = 8'h00; // 00 in BCD
    pm_state = 1'b0; // AM
end

// Clock the counters on the positive edge of clk
always @(posedge clk) begin
    if (reset) begin
        // Reset counters to 12:00 AM
        hour   = 8'h12;  // 12 in BCD
        minute = 8'h00; // 00 in BCD
        second = 8'h00; // 00 in BCD
        pm_state = 1'b0; // AM
    end else if (ena) begin
        // Increment counters once per second
        if (second == 8'h59) begin // 59 in BCD
            second = 8'h00; // 00 in BCD
            if (minute == 8'h59) begin // 59 in BCD
                minute = 8'h00; // 00 in BCD
                if (hour == 8'h12) begin // 12 in BCD
                    hour = 8'h01; // 01 in BCD
                    pm_state = 1'b1; // PM
                end else if (hour == 8'h12 + 12) begin // 12 in BCD + 12 (PM)
                    hour = 8'h12; // 12 in BCD
                    pm_state = 1'b0; // AM
                end else begin
                    hour = hour + 1;
                end
            end else begin
                minute = minute + 1;
            end
        end else begin
            second = second + 1;
        end
    end
end

// Assign outputs
assign hh = hour;
assign mm = minute;
assign ss = second;
assign pm = pm_state;

endmodule