module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0;
        pm <= 1'b0;
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0;
                    pm <= ~pm;
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

always @(posedge clk) begin
    // Output logic
    if (hours == 4'd0) begin
        hh <= 8'd12;
    end else if (hours > 4'd12) begin
        hh <= {4'b1, hours - 4'd12};
    end else begin
        hh <= {4'b0, hours};
    end
    if (minutes < 6'd10) begin
        mm <= {2'b0, minutes};
    end else begin
        mm <= {1'b0, minutes[5:4], 4'b1, minutes[3:0]};
    end
    if (seconds < 6'd10) begin
        ss <= {2'b0, seconds};
    end else begin
        ss <= {1'b0, seconds[5:4], 4'b1, seconds[3:0]};
    end
end

endmodule