module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
    parameter RED_DURATION = 10, YELLOW_DURATION = 5, GREEN_DURATION = 60;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 0;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
            case (state)
                s1_red: begin
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                    if (cnt == RED_DURATION - 1) begin
                        next_state <= s3_green;
                        cnt <= 0;
                    end else begin
                        next_state <= s1_red;
                        cnt <= cnt + 1;
                    end
                end
                s2_yellow: begin
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                    if (cnt == YELLOW_DURATION - 1) begin
                        next_state <= s1_red;
                        cnt <= 0;
                    end else begin
                        next_state <= s2_yellow;
                        cnt <= cnt + 1;
                    end
                end
                s3_green: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                    if (pass_request && cnt > 10) begin
                        next_state <= s2_yellow;
                        cnt <= 0;
                    end else if (cnt == GREEN_DURATION - 1) begin
                        next_state <= s2_yellow;
                        cnt <= 0;
                    end else begin
                        next_state <= s3_green;
                        cnt <= cnt + 1;
                    end
                end
                default: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                    next_state <= s1_red;
                    cnt <= 0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule