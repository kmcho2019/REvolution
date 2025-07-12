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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(state or cnt or pass_request) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if (state == s1_red && p_red == 0) cnt <= 10;
        else if (state == s3_green && p_green == 0 && pass_request) cnt <= 10;
        else if (state == s3_green && p_green == 0 && !pass_request) cnt <= 60;
        else if (state == s2_yellow && p_yellow == 0) cnt <= 5;
        else if (state == s1_red && p_red == 0) cnt <= 10;
        else cnt <= cnt - 1;
        
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

assign clock = cnt;
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule