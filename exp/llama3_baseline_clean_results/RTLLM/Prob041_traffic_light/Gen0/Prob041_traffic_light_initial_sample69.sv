module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

    enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;
    logic [7:0] cnt;
    logic p_red, p_yellow, p_green;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            state <= next_state;
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

    always_comb begin
        case (state)
            idle: next_state = s1_red;
            s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
            s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
            s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
            default: next_state = idle;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            if (pass_request && green) begin
                cnt <= (cnt > 10) ? 10 : cnt;
            end else if (!green && p_green) begin
                cnt <= 60;
            end else if (!yellow && p_yellow) begin
                cnt <= 5;
            end else if (!red && p_red) begin
                cnt <= 10;
            end else begin
                cnt <= (cnt > 0) ? cnt - 1 : cnt;
            end

            case (state)
                idle: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
                s1_red: begin
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
                s2_yellow: begin
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end
                s3_green: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end
                default: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule