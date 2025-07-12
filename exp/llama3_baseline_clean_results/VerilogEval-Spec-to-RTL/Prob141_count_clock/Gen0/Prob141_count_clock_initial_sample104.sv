module TopModule(
    input  clk,         // fast-running clock
    input  reset,        // active high synchronous reset
    input  ena,          // enable signal to increment clock
    output pm,           // AM/PM indicator (1 for PM, 0 for AM)
    output [7:0] hh,     // hours (BCD, 01-12)
    output [7:0] mm,     // minutes (BCD, 00-59)
    output [7:0] ss      // seconds (BCD, 00-59)
);

reg [3:0] hour;
reg [5:0] minute;
reg [5:0] second;
reg pm_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00 AM
        hour <= 0;
        minute <= 0;
        second <= 0;
        pm_reg <= 0;
    end else if (ena) begin
        // Increment seconds
        if (second == 59) begin
            second <= 0;
            // Increment minutes
            if (minute == 59) begin
                minute <= 0;
                // Increment hours
                if (hour == 11) begin
                    hour <= 0;
                    // Toggle AM/PM
                    pm_reg <= ~pm_reg;
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                minute <= minute + 1;
            end
        end else begin
            second <= second + 1;
        end
    end
end

// Assign outputs
assign hh = (hour % 10)? {4'h0, hour} : {4'h1, hour - 10};  // Convert to BCD
assign mm = (minute % 10)? {4'h0, minute[3:0]} : {4'h1, minute[3:0] - 10};  // Convert to BCD
assign ss = (second % 10)? {4'h0, second[3:0]} : {4'h1, second[3:0] - 10};  // Convert to BCD
assign pm = pm_reg;

endmodule