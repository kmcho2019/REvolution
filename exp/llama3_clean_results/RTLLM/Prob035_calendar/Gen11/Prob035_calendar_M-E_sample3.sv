module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 5'd0;
    end else begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 5'd23) begin
                    hours <= 5'd0;
                end else begin
                    hours <= hours + 1'd1;
                end
            end else begin
                minutes <= minutes + 1'd1;
            end
        end else begin
            seconds <= seconds + 1'd1;
        end
    end
    Secs <= seconds;
    Mins <= minutes;
    Hours <= hours;
end

endmodule