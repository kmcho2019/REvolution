module traffic_light(
    input  logic rst_n,
    input  logic clk,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

logic [7:0] cnt;
logic p_red, p_yellow, p_green;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
        end
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
                next_state = s2_yellow;
            end else begin
                next_state = s3_green;
            end
        end
        default: begin
            next_state = idle;
        end
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red && p_red) begin
            cnt <= 10;
        end else if (state == s3_green && p_green) begin
            cnt <= (cnt == 0) ? 60 : cnt - 1;
        end else if (state == s2_yellow && p_yellow) begin
            cnt <= 5;
        end else if (pass_request && p_green && cnt > 10) begin
            cnt <= 10;
        end else begin
            cnt <= (cnt == 0) ? 60 : cnt - 1;
        end
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule