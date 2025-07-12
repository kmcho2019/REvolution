module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours; // 1-12 for 12-hour format
reg [5:0] minutes;
reg [5:0] seconds;
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 12; // Reset hours to 12
        minutes <= 0;
        seconds <= 0;
        am_pm <= 0; // Reset to AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 12) begin
                    hours <= 1;
                    am_pm <= ~am_pm; // Switch AM/PM
                end else if (hours == 11) begin
                    hours <= 12;
                    am_pm <= ~am_pm; // Switch AM/PM
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

// Convert binary to BCD directly in an always block
reg [7:0] hh_reg;
reg [7:0] mm_reg;
reg [7:0] ss_reg;

always @(posedge clk) begin
    if (reset) begin
        hh_reg <= 8'b00010000; // Reset hours to 12 (BCD: 0001 0000)
        mm_reg <= 8'b00000000; // Reset minutes to 00
        ss_reg <= 8'b00000000; // Reset seconds to 00
    end else begin
        // Binary to BCD conversion for hours
        if (hours < 10) begin
            hh_reg <= {4'b0000, 4'b0000, hours};
        end else begin
            hh_reg <= {4'b0000, 4'b0001, hours % 10};
        end
        
        // Binary to BCD conversion for minutes
        if (minutes < 10) begin
            mm_reg <= {4'b0000, 4'b0000, minutes};
        end else begin
            mm_reg <= {4'b0000, minutes / 10, minutes % 10};
        end
        
        // Binary to BCD conversion for seconds
        if (seconds < 10) begin
            ss_reg <= {4'b0000, 4'b0000, seconds};
        end else begin
            ss_reg <= {4'b0000, seconds / 10, seconds % 10};
        end
    end
end

assign hh = hh_reg;
assign mm = mm_reg;
assign ss = ss_reg;
assign pm = am_pm;

endmodule