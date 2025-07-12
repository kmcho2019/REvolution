module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hour_int;
reg [5:0] minute_int;
reg [5:0] second_int;

always @(posedge clk) begin
    if (reset) begin
        hour_int <= 0;
        minute_int <= 0;
        second_int <= 0;
    end else if (ena) begin
        if (second_int == 59) begin
            second_int <= 0;
            if (minute_int == 59) begin
                minute_int <= 0;
                if (hour_int == 11) begin
                    hour_int <= 0;
                end else begin
                    hour_int <= hour_int + 1;
                end
            end else begin
                minute_int <= minute_int + 1;
            end
        end else begin
            second_int <= second_int + 1;
        end
    end
end

assign pm = (hour_int >= 6)? 1'b1 : 1'b0;
assign hh = (hour_int == 0)? 8'h12 : (hour_int < 10)? {4'h0, hour_int} : {4'h1, hour_int};
assign mm = (minute_int < 10)? {4'h0, minute_int} : {4'h1, minute_int[3:0]};
assign ss = (second_int < 10)? {4'h0, second_int} : {4'h1, second_int[3:0]};

endmodule