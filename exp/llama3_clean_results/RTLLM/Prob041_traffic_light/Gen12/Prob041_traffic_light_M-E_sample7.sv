module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state;
reg [7:0] cnt;
reg [7:0] red_time, yellow_time, green_time;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd0;
        red_time <= 8'd10;
        yellow_time <= 8'd5;
        green_time <= 8'd60;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
                if (cnt == red_time) begin
                    state <= s3_green;
                    cnt <= 8'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
                if (cnt == yellow_time) begin
                    state <= s1_red;
                    cnt <= 8'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
                if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end else if (cnt == green_time) begin
                    state <= s2_yellow;
                    cnt <= 8'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
                state <= s1_red;
                cnt <= 8'd0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule