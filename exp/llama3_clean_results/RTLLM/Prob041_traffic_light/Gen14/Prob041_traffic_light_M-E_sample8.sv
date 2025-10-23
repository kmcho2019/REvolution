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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        if (pass_request && green && cnt > 10) begin
            cnt <= 10;
        end else if (cnt == 60) begin
            cnt <= 0;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else if (cnt == 65) begin
            cnt <= cnt + 1;
            red <= 0;
            yellow <= 1;
            green <= 0;
        end else if (cnt == 70) begin
            cnt <= cnt + 1;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            cnt <= cnt + 1;
            if (cnt < 60) begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end else if (cnt < 65) begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end else begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
        end
    end
end

assign clock = cnt;

endmodule