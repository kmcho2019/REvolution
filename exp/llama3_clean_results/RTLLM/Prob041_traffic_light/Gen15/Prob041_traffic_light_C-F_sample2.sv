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
    parameter RED_TIME = 10, GREEN_TIME = 60, YELLOW_TIME = 5;

    reg [1:0] state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= RED_TIME;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red;
                    cnt <= RED_TIME;
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= idle;
                end
            endcase
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
        end
    end

    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;
    assign clock = cnt;

endmodule