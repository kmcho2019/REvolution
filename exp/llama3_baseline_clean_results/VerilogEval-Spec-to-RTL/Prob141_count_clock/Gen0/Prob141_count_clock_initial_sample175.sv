module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] bcd_ss;
reg [3:0] bcd_mm;
reg [3:0] bcd_hh;

always @(posedge clk) begin
    if (reset) begin
        // Reset all counters and signals
        bcd_ss <= 4'b0000; // 00 in BCD
        bcd_mm <= 4'b0000; // 00 in BCD
        bcd_hh <= 4'b0001; // 01 in BCD (1 o'clock)
    end else if (ena) begin
        // Increment seconds counter
        if (bcd_ss == 4'b1001) begin // 59 in BCD
            bcd_ss <= 4'b0000; // Reset to 00
            // Increment minutes counter
            if (bcd_mm == 4'b1001) begin // 59 in BCD
                bcd_mm <= 4'b0000; // Reset to 00
                // Increment hours counter
                if (bcd_hh == 4'b1001) begin // 12 o'clock (PM) or 11 o'clock (AM)
                    bcd_hh <= 4'b0001; // Reset to 1 o'clock (AM)
                end else begin
                    bcd_hh <= bcd_hh + 4'b0001;
                end
            end else begin
                bcd_mm <= bcd_mm + 4'b0001;
            end
        end else begin
            bcd_ss <= bcd_ss + 4'b0001;
        end
    end
end

// Assign output signals
assign pm = (bcd_hh >= 4'b1000); // PM if hour is greater than or equal to 12
assign hh = {bcd_hh, 4'b0000}; // BCD hours
assign mm = {bcd_mm, 4'b0000}; // BCD minutes
assign ss = {bcd_ss, 4'b0000}; // BCD seconds

endmodule