module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output red, yellow, green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

always @(*)
begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        if (state == s1_red) begin
            cnt <= (cnt == 0) ? 10 : cnt - 1;
            p_red <= 1;
            p_yellow <= 0;
            p_green <= 0;
        end else if (state == s2_yellow) begin
            cnt <= (cnt == 0) ? 5 : cnt - 1;
            p_red <= 0;
            p_yellow <= 1;
            p_green <= 0;
        end else if (state == s3_green) begin
            if (pass_request && cnt > 10) begin
                cnt <= 10;
            end else if (cnt == 0) begin
                cnt <= 60;
            end else begin
                cnt <= cnt - 1;
            end
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 1;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
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