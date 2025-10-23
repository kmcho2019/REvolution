module traffic_light(
    input rst_n, clk, pass_request,
    output reg [7:0] clock,
    output reg red, yellow, green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                next_state <= s1_red;
                if (cnt == 8'd0) begin
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s1_red: begin
                next_state <= s1_red;
                if (cnt == 8'd0) begin
                    next_state <= s3_green;
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
                if (pass_request && p_green) begin
                    cnt <= 8'd10;
                end
            end
            s2_yellow: begin
                next_state <= s2_yellow;
                if (cnt == 8'd0) begin
                    next_state <= s1_red;
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                next_state <= s3_green;
                if (cnt == 8'd0) begin
                    next_state <= s2_yellow;
                    cnt <= 8'd5;
                end else begin
                    cnt <= cnt - 1;
                end
                if (pass_request && p_green && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end
            end
        endcase
        state <= next_state;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
        endcase
    end
end

assign clock = cnt;

endmodule