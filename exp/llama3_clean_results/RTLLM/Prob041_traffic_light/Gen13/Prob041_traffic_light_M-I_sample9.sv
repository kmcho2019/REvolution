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
reg clk_enable;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        red <= 0;
        yellow <= 0;
        green <= 0;
        clk_enable <= 1'b1;
    end else begin
        state <= next_state;
        if (state == s1_red && cnt == 0) begin
            cnt <= 60;
        end else if (state == s2_yellow && cnt == 0) begin
            cnt <= 5;
        end else if (state == s3_green && cnt == 0) begin
            if (pass_request) begin
                cnt <= 10;
            end else begin
                cnt <= 60;
            end
        end else if (cnt > 0) begin
            if (clk_enable) begin
                cnt <= cnt - 1;
            end
        end
        case (state)
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
                clk_enable <= 1'b1;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
                clk_enable <= 1'b1;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
                if (pass_request) begin
                    clk_enable <= 1'b1;
                end else begin
                    clk_enable <= 1'b0;
                end
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
                clk_enable <= 1'b1;
            end
        endcase
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

assign clock = cnt;

endmodule