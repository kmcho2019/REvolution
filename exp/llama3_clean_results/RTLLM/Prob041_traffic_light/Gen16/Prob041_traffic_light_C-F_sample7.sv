module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        if (pass_request && p_green) begin
            cnt <= 8'd10;
        end else if (cnt == 0) begin
            case (state)
                s1_red: cnt <= 8'd60;
                s2_yellow: cnt <= 8'd5;
                s3_green: cnt <= 8'd10;
                default: cnt <= 8'd10;
            endcase
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
        p_red <= (state == s1_red) ? 1'b1 : 1'b0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 1'b0;
        p_green <= (state == s3_green) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
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