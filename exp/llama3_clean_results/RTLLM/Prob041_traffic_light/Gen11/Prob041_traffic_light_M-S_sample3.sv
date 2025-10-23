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
reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 8'd10;
            end
            s1_red: begin
                if (cnt == 8'd0) begin
                    state <= s3_green;
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 8'd0) begin
                    state <= s2_yellow;
                    cnt <= 8'd5;
                end else if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 8'd0) begin
                    state <= s1_red;
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule