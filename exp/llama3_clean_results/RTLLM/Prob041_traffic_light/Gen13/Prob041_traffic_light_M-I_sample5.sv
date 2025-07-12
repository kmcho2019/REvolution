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
reg [7:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        red <= 0;
        yellow <= 0;
        green <= 0;
        counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (rst_n) begin
        case (state)
            s1_red: begin
                if (cnt == 0) begin
                    next_state <= s3_green;
                end else begin
                    next_state <= s1_red;
                end
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 60;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state <= s1_red;
                end else begin
                    next_state <= s2_yellow;
                end
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 5;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    next_state <= s2_yellow;
                end else if (pass_request && cnt > 10) begin
                    next_state <= s3_green;
                    cnt <= 10;
                end else begin
                    next_state <= s3_green;
                end
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 60;
                end
            end
            default: begin
                next_state <= s1_red;
                cnt <= 10;
            end
        endcase
    end
end

assign clock = cnt;

endmodule