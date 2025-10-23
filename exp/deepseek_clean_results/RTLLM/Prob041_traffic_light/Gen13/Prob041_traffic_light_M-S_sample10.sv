module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
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
        cnt <= 10; // Red time
    end else begin
        if (cnt == 0) begin
            // State transition
            if (red) begin
                red <= 0;
                green <= 1;
                cnt <= 60; // Green time
            end else if (yellow) begin
                yellow <= 0;
                red <= 1;
                cnt <= 10; // Red time
            end else if (green) begin
                green <= 0;
                yellow <= 1;
                cnt <= 5; // Yellow time
            end
        end else begin
            // Handle pedestrian request only during green
            if (pass_request && green && cnt > 10) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end
end

assign clock = cnt;

endmodule