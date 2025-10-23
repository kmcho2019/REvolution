module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
        cnt <= RED_TIME;
    end else begin
        if (cnt == 1) begin
            // State transition
            if (red) begin
                red <= 0;
                green <= 1;
                cnt <= GREEN_TIME;
            end else if (yellow) begin
                yellow <= 0;
                red <= 1;
                cnt <= RED_TIME;
            end else if (green) begin
                green <= 0;
                yellow <= 1;
                cnt <= YELLOW_TIME;
            end
        end else begin
            // Handle pedestrian request only during green
            if (pass_request && green && (cnt > MIN_GREEN))
                cnt <= MIN_GREEN;
            else
                cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

endmodule