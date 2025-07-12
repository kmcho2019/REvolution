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
        hh <= 8'd12;
        mm <= 8'd0;
        ss <= 8'd0;
    end else if (ena) begin
        // Increment seconds, minutes, and hours
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0;
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
        
        // Convert internal counters to BCD and update AM/PM
        hh <= (hours == 4'd0) ? 8'd12 : {4'b0, hours};
        pm <= (hours >= 4'd6) ? 1'b1 : 1'b0;
        mm <= {2'b0, minutes};
        ss <= {2'b0, seconds};
    end
end

endmodule