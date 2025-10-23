module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] h; // Hours in BCD (01-12)
reg [5:0] m; // Minutes in BCD (00-59)
reg [5:0] s; // Seconds in BCD (00-59)
reg pm_reg; // AM/PM indicator

always @ (posedge clk) begin
    if (reset) begin
        h <= 4'b1100; // Reset hours to 12:00 AM in BCD
        m <= 6'b000000;
        s <= 6'b000000;
        pm_reg <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (s == 6'b100111) begin // Check if seconds are 59
            s <= 6'b000000; // Reset seconds
            if (m == 6'b100111) begin // Check if minutes are 59
                m <= 6'b000000; // Reset minutes
                if (h == 4'b1100 && pm_reg == 1'b1) begin // Check if hour is 12 PM
                    h <= 4'b0001; // Set hour to 1 AM
                    pm_reg <= 1'b0; // Set to AM
                end else if (h == 4'b1100 && pm_reg == 1'b0) begin // Check if hour is 12 AM
                    h <= 4'b0001; // Set hour to 1 PM
                    pm_reg <= 1'b1; // Set to PM
                end else if (h == 4'b1001) begin // Check if hour is 1
                    h <= 4'b0010; // Increment hour to 2
                end else begin
                    h <= h + 1'b1; // Increment hour
                end
            end else begin
                m <= m + 1'b1; // Increment minutes
            end
        end else begin
            s <= s + 1'b1; // Increment seconds
        end
    end
end

assign hh = {4'b0000, h}; // Pad hours with zeros
assign mm = {2'b00, m[5:4], m[3:0]}; // Correctly assign minutes
assign ss = {2'b00, s[5:4], s[3:0]}; // Correctly assign seconds
assign pm = pm_reg;

endmodule