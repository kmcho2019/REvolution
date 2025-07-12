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

reg [1:0] state;
reg [7:0] cnt;

// State machine logic
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
            s1_red: if (cnt == 0) begin
                state <= s3_green;
                cnt <= 8'd60;
            end else begin
                cnt <= cnt - 1;
            end
            s2_yellow: if (cnt == 0) begin
                state <= s1_red;
                cnt <= 8'd10;
            end else begin
                cnt <= cnt - 1;
            end
            s3_green: if (cnt == 0) begin
                state <= s2_yellow;
                cnt <= 8'd5;
            end else if (pass_request && cnt > 10) begin
                cnt <= 8'd10;
            end else begin
                cnt <= cnt - 1;
            end
            default: state <= idle;
        endcase
    end
end

// Signal assignments
assign clock = cnt;
assign red = (state == s1_red) ? 1'b1 : 1'b0;
assign yellow = (state == s2_yellow) ? 1'b1 : 1'b0;
assign green = (state == s3_green) ? 1'b1 : 1'b0;

endmodule