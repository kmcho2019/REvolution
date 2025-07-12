module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

reg [7:0] cnt;
reg [7:0] red_cnt;
reg [7:0] yellow_cnt;
reg [7:0] green_cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd0;
        red_cnt <= 8'd10;
        yellow_cnt <= 8'd5;
        green_cnt <= 8'd60;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        cnt <= cnt + 1;
        if (cnt >= green_cnt) begin
            red <= 1;
            yellow <= 0;
            green <= 0;
            cnt <= 0;
        end else if (cnt >= green_cnt - 5) begin
            red <= 0;
            yellow <= 1;
            green <= 0;
        end else if (cnt >= green_cnt - 5 - 10) begin
            red <= 0;
            yellow <= 0;
            green <= 1;
        end
        if (pass_request && green && cnt > green_cnt - 10) begin
            green_cnt <= 8'd10;
        end
    end
end

assign clock = cnt;

endmodule