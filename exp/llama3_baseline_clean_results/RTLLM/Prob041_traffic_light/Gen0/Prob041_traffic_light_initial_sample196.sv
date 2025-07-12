module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;
logic [7:0] cnt, next_cnt;
logic p_red, p_yellow, p_green;

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end
    else begin
        state <= next_state;
        cnt <= next_cnt;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always_comb begin
    next_state = state;
    next_cnt = cnt;
    case (state)
        idle: begin
            next_state = s1_red;
        end
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
            end
        end
        s3_green: begin
            if (cnt == 0) begin
                next_state = s2_yellow;
            end
        end
        default: begin
            next_state = idle;
        end
    endcase
    if (pass_request && p_green && cnt > 10) begin
        next_cnt = 10;
    end
    else if (!p_green && p_green != green && state == s3_green) begin
        next_cnt = 60;
    end
    else if (!p_yellow && p_yellow != yellow && state == s2_yellow) begin
        next_cnt = 5;
    end
    else if (!p_red && p_red != red && state == s1_red) begin
        next_cnt = 10;
    end
    else begin
        next_cnt = cnt - 1;
    end
end

always_comb begin
    case (state)
        idle: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
        s1_red: begin
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
        end
        s2_yellow: begin
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
        end
        s3_green: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
        end
        default: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
    endcase
end

assign clock = cnt;

endmodule