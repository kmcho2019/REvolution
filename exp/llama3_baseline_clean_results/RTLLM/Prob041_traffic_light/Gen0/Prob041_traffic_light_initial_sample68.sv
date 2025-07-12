module traffic_light(
    input rst_n, clk, pass_request,
    output reg [7:0] clock,
    output reg red, yellow, green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    always @(*) begin
        case(state)
            idle: next_state = s1_red;
            s1_red: next_state = (cnt == 10) ? s3_green : s1_red;
            s2_yellow: next_state = (cnt == 5) ? s1_red : s2_yellow;
            s3_green: next_state = (cnt == 60) ? s2_yellow : s3_green;
            default: next_state = idle;
        endcase
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            state <= next_state;
            if (state == s1_red) begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end else if (state == s2_yellow) begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end else if (state == s3_green) begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
            end
            if (pass_request && p_green) begin
                if (cnt > 10) begin
                    cnt <= 10;
                end
            end else if (!p_green && p_green != 0) begin
                cnt <= 60;
            end else if (!p_yellow && p_yellow != 0) begin
                cnt <= 5;
            end else if (!p_red && p_red != 0) begin
                cnt <= 10;
            end else begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= cnt;
                end
            end
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    assign clock = cnt;

endmodule