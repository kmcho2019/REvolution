module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    parameter idle = 2'b00, red_state = 2'b01, yellow_state = 2'b10, green_state = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] green_cnt, yellow_red_cnt;
    reg [7:0] next_green_cnt, next_yellow_red_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            green_cnt <= 60;
            yellow_red_cnt <= 10;
        end else begin
            state <= next_state;
            green_cnt <= next_green_cnt;
            yellow_red_cnt <= next_yellow_red_cnt;
        end
    end

    always @(*) begin
        next_state = state;
        next_green_cnt = green_cnt;
        next_yellow_red_cnt = yellow_red_cnt;

        case (state)
            idle: begin
                next_state = red_state;
                next_green_cnt = 60;
                next_yellow_red_cnt = 10;
            end
            red_state: begin
                next_yellow_red_cnt = yellow_red_cnt - 1;
                if (yellow_red_cnt == 1) begin
                    next_state = green_state;
                    next_green_cnt = 60;
                end
            end
            green_state: begin
                next_green_cnt = green_cnt - 1;
                if (pass_request && green_cnt > 10) begin
                    next_green_cnt = 10;
                end
                if (green_cnt == 1) begin
                    next_state = yellow_state;
                    next_yellow_red_cnt = 5;
                end
            end
            yellow_state: begin
                next_yellow_red_cnt = yellow_red_cnt - 1;
                if (yellow_red_cnt == 1) begin
                    next_state = red_state;
                    next_yellow_red_cnt = 10;
                end
            end
            default: next_state = idle;
        endcase
    end

    assign red = (state == red_state) ? 1 : 0;
    assign yellow = (state == yellow_state) ? 1 : 0;
    assign green = (state == green_state) ? 1 : 0;
    assign clock = (state == green_state) ? green_cnt : (state == yellow_state || state == red_state) ? yellow_red_cnt : 0;

endmodule