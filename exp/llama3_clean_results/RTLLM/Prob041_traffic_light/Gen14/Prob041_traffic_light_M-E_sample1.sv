module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
    parameter green_time = 60, yellow_time = 5, red_time = 10;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= red_time;
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= green_time;
                        red <= 0;
                        yellow <= 0;
                        green <= 1;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= red_time;
                        red <= 1;
                        yellow <= 0;
                        green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= yellow_time;
                        red <= 0;
                        yellow <= 1;
                        green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= s1_red;
                    cnt <= red_time;
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule