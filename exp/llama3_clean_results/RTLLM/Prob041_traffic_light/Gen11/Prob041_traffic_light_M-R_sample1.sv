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

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
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

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        if (pass_request && green) begin
            cnt <= 8'd10;
        end else if (cnt == 0) begin
            case (state)
                s1_red: cnt <= 8'd60;
                s2_yellow: cnt <= 8'd10;
                s3_green: cnt <= 8'd5;
                default: cnt <= 8'd10;
            endcase
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Signal assignments
assign clock = cnt;
assign red = (state == s1_red) ? 1'b1 : 1'b0;
assign yellow = (state == s2_yellow) ? 1'b1 : 1'b0;
assign green = (state == s3_green) ? 1'b1 : 1'b0;

endmodule