module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;
reg [31:0] counter;

assign pm = (hours[3:0] > 11);
assign hh = {hours[3:0], 4'b0000};
assign mm = {minutes[3:0], 4'b0000};
assign ss = {seconds[3:0], 4'b0000};

always @(posedge clk) begin
    if (reset) begin
        counter <= 32'd0;
        seconds <= 8'd0;
        minutes <= 8'd0;
        hours <= 8'd1;
    end else if (ena) begin
        counter <= counter + 1;
        if (counter == 32'd100000000) begin
            counter <= 32'd0;
            if (seconds == 8'd59) begin
                seconds <= 8'd0;
                if (minutes == 8'd59) begin
                    minutes <= 8'd0;
                    if (hours == 8'd12) begin
                        hours <= 8'd1;
                    end else begin
                        hours <= hours + 8'd1;
                    end
                end else begin
                    minutes <= minutes + 8'd1;
                end
            end else begin
                seconds <= seconds + 8'd1;
            end
        end
    end
end

endmodule