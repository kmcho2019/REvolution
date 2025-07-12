module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    parameter idle = 2'b00, red_state = 2'b01, yellow_state = 2'b10, green_state = 2'b11;
    parameter green_time = 60, yellow_time = 5, red_time = 10;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd0;
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                red_state: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                    if (cnt == red_time) begin
                        cnt <= 8'd0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                yellow_state: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                    if (cnt == yellow_time) begin
                        cnt <= 8'd0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                green_state: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                    if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else if (cnt == green_time) begin
                        cnt <= 8'd0;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                    cnt <= 8'd0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            idle: next_state = red_state;
            red_state: if (cnt == red_time) next_state = green_state; else next_state = red_state;
            yellow_state: if (cnt == yellow_time) next_state = red_state; else next_state = yellow_state;
            green_state: if (cnt == green_time || (pass_request && cnt == 10)) next_state = yellow_state; else next_state = green_state;
            default: next_state = idle;
        endcase
    end

    assign clock = cnt;

endmodule