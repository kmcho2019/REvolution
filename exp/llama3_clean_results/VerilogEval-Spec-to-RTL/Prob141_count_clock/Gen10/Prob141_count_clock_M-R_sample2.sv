module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours; // BCD hours (01-12)
reg [5:0] minutes; // Binary minutes (00-59)
reg [5:0] seconds; // Binary seconds (00-59)
reg pm_flag; // AM/PM flag

// Initialize the clock to 12:00:00 AM
initial begin
    hours = 4'b0001; // 12 in BCD
    minutes = 6'b000000; // 00 in binary
    seconds = 6'b000000; // 00 in binary
    pm_flag = 1'b0; // AM
end

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        hours <= 4'b0001;
        minutes <= 6'b000000;
        seconds <= 6'b000000;
        pm_flag <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'b001110) begin // 59 in binary
            seconds <= 6'b000000; // Reset to 00
            // Increment minutes
            if (minutes == 6'b001110) begin // 59 in binary
                minutes <= 6'b000000; // Reset to 00
                // Increment hours
                case (hours)
                    4'b1001: begin // 12 in BCD
                        hours <= 4'b0001; // 1 in BCD, toggle AM/PM
                        pm_flag <= ~pm_flag;
                    end
                    default: hours <= hours + 1'b1; // Increment hours
                endcase
            end else begin
                minutes <= minutes + 1'b1; // Increment minutes
            end
        end else begin
            seconds <= seconds + 1'b1; // Increment seconds
        end
    end
end

// BCD encoding for output signals
assign hh = {4'b0000, hours};
assign mm = {4'b0000, minutes[3:0]};
assign ss = {4'b0000, seconds[3:0]};
assign pm = pm_flag;

endmodule