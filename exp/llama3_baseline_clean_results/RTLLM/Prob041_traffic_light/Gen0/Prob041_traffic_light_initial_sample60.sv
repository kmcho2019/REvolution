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
        cnt <= 8'd10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                next_state <= s1_red;
                cnt <= 8'd10;
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s1_red: begin
                if (cnt == 8'd0) begin
                    next_state <= s3_green;
                    cnt <= 8'd60;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end else begin
                    next_state <= s1_red;
                    cnt <= cnt - 1;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
            end
            s2_yellow: begin
                if (cnt == 8'd0) begin
                    next_state <= s1_red;
                    cnt <= 8'd10;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end else begin
                    next_state <= s2_yellow;
                    cnt <= cnt - 1;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end
                if (cnt == 8'd0) begin
                    next_state <= s2_yellow;
                    cnt <= 8'd5;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end else begin
                    next_state <= s3_green;
                    cnt <= cnt - 1;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end
            end
            default: begin
                next_state <= idle;
                cnt <= 8'd10;
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
        endcase
        state <= next_state;
    end
end

always_comb begin
    red = p_red;
    yellow = p_yellow;
    green = p_green;
    clock = cnt;
end

endmodule