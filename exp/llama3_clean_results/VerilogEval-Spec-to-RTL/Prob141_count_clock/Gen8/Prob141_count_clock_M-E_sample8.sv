module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [4:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 1; // Initial hours (01)
        minutes <= 0; // Initial minutes (00)
        seconds <= 0; // Initial seconds (00)
        am_pm <= 0; // Initial AM/PM flag (AM)
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 1;
                    am_pm <= ~am_pm; // Toggle AM/PM
                end else if (hours == 12) begin
                    hours <= 1;
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

// Convert binary to BCD
always @(posedge clk) begin
    if (hours < 10) begin
        hh <= {4'b0000, hours};
    end else begin
        hh <= {4'b0001, hours - 10};
    end
    
    if (minutes < 10) begin
        mm <= {6'b000000, minutes};
    end else if (minutes < 60) begin
        mm <= {4'b0000, minutes / 10, minutes % 10};
    end else begin
        mm <= 0;
    end
    
    if (seconds < 10) begin
        ss <= {6'b000000, seconds};
    end else if (seconds < 60) begin
        ss <= {4'b0000, seconds / 10, seconds % 10};
    end else begin
        ss <= 0;
    end
end

assign pm = am_pm;

endmodule