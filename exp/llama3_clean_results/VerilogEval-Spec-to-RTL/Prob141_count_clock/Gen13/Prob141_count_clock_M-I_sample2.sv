module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd12; // Initialize hours to 12
        minutes <= 6'd0;
        seconds <= 6'd0;
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd12) begin
                    hours <= 4'd1; // Correct wrap-around from 12 to 1
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

assign pm = (hours >= 4'd12 || (hours > 4'd0 && hours < 4'd12))? 1'b1 : 1'b0; // Correct PM indicator
assign hh = {4'd0, hours};
assign mm = {2'd0, minutes};
assign ss = {2'd0, seconds};

endmodule