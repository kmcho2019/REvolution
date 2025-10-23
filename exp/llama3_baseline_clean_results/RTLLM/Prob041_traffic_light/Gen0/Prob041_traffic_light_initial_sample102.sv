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

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(state or pass_request or cnt) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
            end else begin
                next_state = s1_red;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
            end else begin
                next_state = s2_yellow;
            end
        end
        s3_green: begin
            if (cnt == 0) begin
                next_state = s2_yellow;
            end else if (pass_request && cnt > 10) begin
                next_state = s3_green;
            end else begin
                next_state = s3_green;
            end
        end
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red && p_red) begin
            cnt <= 10;
        end else if (state == s3_green && p_green && pass_request) begin
            cnt <= 10;
        end else if (state == s3_green && ~p_green && p_green == 1) begin
            cnt <= 60;
        end else if (state == s2_yellow && ~p_yellow && p_yellow == 1) begin
            cnt <= 5;
        end else if (state == s1_red && ~p_red && p_red == 1) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule