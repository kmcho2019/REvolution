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
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            state <= next_state;
            cnt <= (pass_request && p_green) ? 10 : (cnt == 0) ? (state == s1_red) ? 60 : (state == s2_yellow) ? 10 : (state == s3_green) ? 5 : 10 : cnt - 1;
            p_red <= (state == s1_red) ? 1 : 0;
            p_yellow <= (state == s2_yellow) ? 1 : 0;
            p_green <= (state == s3_green) ? 1 : 0;
        end
    end

    always @(*) begin
        case (state)
            idle: next_state = s1_red;
            s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
            s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
            s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
            default: next_state = idle;
        endcase
    end

    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;
    assign clock = cnt;

endmodule