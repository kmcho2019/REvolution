module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg red,
    output reg yellow,
    output reg green
);

reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
        cnt <= 10;
    end else begin
        if (cnt == 0) begin
            // State transition
            if (red) begin
                red <= 0;
                green <= 1;
                cnt <= 60;
            end else if (green) begin
                green <= 0;
                yellow <= 1;
                cnt <= 5;
            end else begin // yellow
                yellow <= 0;
                red <= 1;
                cnt <= 10;
            end
        end else begin
            cnt <= cnt - 1;
            // Handle pedestrian request
            if (pass_request && green && cnt > 10)
                cnt <= 10;
        end
    end
end

endmodule