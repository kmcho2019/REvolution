module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hour_reg; // Hours in BCD (01-12)
reg [5:0] minute_reg; // Minutes in BCD (00-59)
reg [5:0] second_reg; // Seconds in BCD (00-59)
reg pm_reg; // AM/PM indicator

always @ (posedge clk) begin
    if (reset) begin
        hour_reg <= 4'b1001; // Reset hours to 12:00 AM in BCD (01-12)
        minute_reg <= 6'b000000;
        second_reg <= 6'b000000;
        pm_reg <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (second_reg == 6'b100111) begin // Check if seconds are 59
            second_reg <= 6'b000000; // Reset seconds
            if (minute_reg == 6'b100111) begin // Check if minutes are 59
                minute_reg <= 6'b000000; // Reset minutes
                if (hour_reg == 4'b1001) begin // Check if hour is 12
                    if (pm_reg == 1'b0) begin
                        hour_reg <= 4'b0001; // Set hour to 1 PM
                        pm_reg <= 1'b1; // Set to PM
                    end else begin
                        hour_reg <= 4'b1001; // Set hour to 12 AM
                        pm_reg <= 1'b0; // Set to AM
                    end
                end else if (hour_reg == 4'b1011) begin // Check if hour is 11
                    hour_reg <= 4'b1001; // Increment hour to 12
                end else begin
                    hour_reg <= hour_reg + 1'b1; // Increment hour
                end
            end else begin
                minute_reg <= minute_reg + 1'b1; // Increment minutes
            end
        end else begin
            second_reg <= second_reg + 1'b1; // Increment seconds
        end
    end
end

assign hh = {4'b0000, hour_reg}; // Pad hours with zeros
assign mm = {2'b00, minute_reg[5:4], minute_reg[3:0]}; // Correctly assign minutes
assign ss = {2'b00, second_reg[5:4], second_reg[3:0]}; // Correctly assign seconds
assign pm = pm_reg;

endmodule