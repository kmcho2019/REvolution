module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter s1_red = 2'b00, s2_yellow = 2'b01, s3_green = 2'b10;

reg [1:0] state, next_state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1_red;
        cnt <= 8'd10;
    end else begin
        state <= next_state;
        case (state)
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 8'd60;
                    state <= s3_green;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 8'd10;
                    state <= s1_red;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 8'd10;
                end
                if (cnt == 0) begin
                    cnt <= 8'd5;
                    state <= s2_yellow;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
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
        endcase
    end
end

assign clock = cnt;

endmodule