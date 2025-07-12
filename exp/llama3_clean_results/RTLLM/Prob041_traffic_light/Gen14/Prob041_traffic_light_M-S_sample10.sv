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
parameter red_count = 8'd10, yellow_count = 8'd5, green_count = 8'd60, min_green_count = 8'd10;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= red_count;
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= red_count;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    cnt <= green_count;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s3_green: begin
                if (pass_request && cnt > min_green_count) begin
                    cnt <= min_green_count;
                end else if (cnt == 0) begin
                    state <= s2_yellow;
                    cnt <= yellow_count;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    cnt <= red_count;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            default: begin
                state <= idle;
                cnt <= red_count;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

assign clock = cnt;

endmodule