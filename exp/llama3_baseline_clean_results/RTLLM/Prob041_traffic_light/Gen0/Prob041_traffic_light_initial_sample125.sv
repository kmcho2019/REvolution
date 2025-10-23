module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

always @(*) begin
    case(state)
        idle: next_state = s1_red;
        s1_red: if(cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if(cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if(cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end
    else begin
        state <= next_state;
        if(pass_request && p_green) cnt <= 10;
        else if(!p_green && p_green) cnt <= 60;
        else if(!p_yellow && p_yellow) cnt <= 5;
        else if(!p_red && p_red) cnt <= 10;
        else if(cnt > 0) cnt <= cnt - 1;
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end
    else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule