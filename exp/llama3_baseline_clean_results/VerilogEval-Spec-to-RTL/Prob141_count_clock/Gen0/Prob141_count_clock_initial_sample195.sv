module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;
reg pm_state;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
        pm_state <= 0;
    end else if (ena) begin
        seconds <= seconds + 1;
        if (seconds == 59) begin
            seconds <= 0;
            minutes <= minutes + 1;
            if (minutes == 59) begin
                minutes <= 0;
                hours <= hours + 1;
                if (hours == 12) begin
                    hours <= 1;
                    pm_state <= ~pm_state;
                end else if (hours == 13) begin
                    hours <= 1;
                end
            end
        end
    end
end

assign pm = pm_state;

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
    end else begin
        case (hours)
            4'd0: hh <= 8'h12;
            4'd1: hh <= 8'h01;
            4'd2: hh <= 8'h02;
            4'd3: hh <= 8'h03;
            4'd4: hh <= 8'h04;
            4'd5: hh <= 8'h05;
            4'd6: hh <= 8'h06;
            4'd7: hh <= 8'h07;
            4'd8: hh <= 8'h08;
            4'd9: hh <= 8'h09;
            4'd10: hh <= 8'h10;
            4'd11: hh <= 8'h11;
            4'd12: hh <= 8'h12;
        endcase
        mm <= minutes;
        ss <= seconds;
    end
end

endmodule