module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

typedef enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state_type;

state_type state, next_state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd0;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        state <= next_state;
        if (cnt == 8'd0) begin
            if (state == s3_green) begin
                if (pass_request && p_green) begin
                    cnt <= 8'd10;
                end else if (!p_green) begin
                    cnt <= 8'd60;
                end else begin
                    cnt <= 8'd60;
                end
            end else if (state == s2_yellow) begin
                cnt <= 8'd5;
            end else if (state == s1_red) begin
                cnt <= 8'd10;
            end
        end else begin
            cnt <= cnt - 8'd1;
        end
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
        s1_red: begin
            next_state = (cnt == 8'd0) ? s3_green : s1_red;
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
        end
        s2_yellow: begin
            next_state = (cnt == 8'd0) ? s1_red : s2_yellow;
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
        end
        s3_green: begin
            next_state = (cnt == 8'd0) ? s2_yellow : s3_green;
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
        end
        default: begin
            next_state = idle;
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
    endcase
end

assign clock = cnt;

endmodule