module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

reg [7:0] cnt;
reg red, yellow, green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        if (cnt == 0) begin
            if (green) begin
                green <= 0;
                yellow <= 1;
                cnt <= 5;
            end else if (yellow) begin
                yellow <= 0;
                red <= 1;
                cnt <= 10;
            end else begin // red
                red <= 0;
                green <= 1;
                cnt <= 60;
            end
        end else begin
            if (pass_request && green && cnt > 10)
                cnt <= 10;
            else
                cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

endmodule