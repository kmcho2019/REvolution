module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output red, yellow, green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;
reg [7:0] next_cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green;
                else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red;
                    else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow;
                  else next_state = s3_green;
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green && cnt > 10) begin
            cnt <= 10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        p_red <= (state == s1_red) ? 1'b1 : 1'b0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 1'b0;
        p_green <= (state == s3_green) ? 1'b1 : 1'b0;
    end
end

assign clock = cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule