module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] counter_seconds;
reg [7:0] counter_minutes;
reg [7:0] counter_hours;

always @(posedge clk) begin
    if (reset) begin
        counter_seconds <= 8'd0;
        counter_minutes <= 8'd0;
        counter_hours <= 8'd1;
        pm <= 1'b0;
    end
    else if (ena) begin
        if (counter_seconds == 8'd59) begin
            counter_seconds <= 8'd0;
            if (counter_minutes == 8'd59) begin
                counter_minutes <= 8'd0;
                if (counter_hours == 8'd12) begin
                    counter_hours <= 8'd1;
                    pm <= 1'b0;
                end
                else if (counter_hours == 8'd12 + 8'd12 - 1) begin
                    counter_hours <= 8'd1;
                    pm <= 1'b0;
                end
                else if (counter_hours < 8'd12) begin
                    counter_hours <= counter_hours + 1;
                    pm <= 1'b0;
                end
                else begin
                    counter_hours <= counter_hours + 1;
                    pm <= 1'b1;
                end
            end
            else begin
                counter_minutes <= counter_minutes + 1;
            end
        end
        else begin
            counter_seconds <= counter_seconds + 1;
        end
    end
end

always @(*) begin
    hh = counter_hours;
    mm = counter_minutes;
    ss = counter_seconds;
end

endmodule