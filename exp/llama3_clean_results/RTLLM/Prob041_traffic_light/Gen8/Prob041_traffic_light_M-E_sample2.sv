module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

reg [1:0] state;
reg [7:0] cnt;
reg [7:0] red_cnt, yellow_cnt, green_cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        cnt <= 8'd10;
    end else begin
        case (state)
            2'b00: begin // idle
                state <= 2'b01;
                cnt <= 8'd10;
            end
            2'b01: begin // red
                if (cnt == 8'd0) begin
                    state <= 2'b10;
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b10: begin // green
                if (cnt == 8'd0) begin
                    state <= 2'b11;
                    cnt <= 8'd5;
                end else if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            2'b11: begin // yellow
                if (cnt == 8'd0) begin
                    state <= 2'b01;
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        2'b01: begin
            red_cnt <= 8'd10;
            yellow_cnt <= 8'd0;
            green_cnt <= 8'd0;
        end
        2'b10: begin
            red_cnt <= 8'd0;
            yellow_cnt <= 8'd0;
            green_cnt <= 8'd60;
        end
        2'b11: begin
            red_cnt <= 8'd0;
            yellow_cnt <= 8'd5;
            green_cnt <= 8'd0;
        end
    endcase
end

assign red = (state == 2'b01);
assign yellow = (state == 2'b11);
assign green = (state == 2'b10);
assign clock = cnt;

endmodule