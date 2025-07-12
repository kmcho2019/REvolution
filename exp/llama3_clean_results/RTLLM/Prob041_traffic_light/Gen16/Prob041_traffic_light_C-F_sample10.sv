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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        state <= next_state;
        case (next_state)
            s1_red: begin
                cnt <= (cnt == 0) ? 10 : cnt - 1;
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                cnt <= (cnt == 0) ? 5 : cnt - 1;
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= (cnt == 0) ? 60 : cnt - 1;
                end
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                cnt <= cnt;
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
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

assign clock = cnt;

endmodule