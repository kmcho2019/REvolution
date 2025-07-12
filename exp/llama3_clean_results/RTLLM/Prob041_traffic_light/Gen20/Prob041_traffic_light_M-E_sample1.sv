module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    parameter S_RED = 2'b00, S_GREEN = 2'b01, S_YELLOW = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg [7:0] red_cnt, green_cnt, yellow_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt <= 8'd10;
            red_cnt <= 8'd10;
            green_cnt <= 8'd60;
            yellow_cnt <= 8'd5;
        end else begin
            state <= next_state;
            case (state)
                S_RED: begin
                    if (cnt == 0) begin
                        cnt <= green_cnt;
                        state <= S_GREEN;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S_GREEN: begin
                    if (pass_request && cnt > 10) begin
                        cnt <= 8'd10;
                    end
                    if (cnt == 0) begin
                        cnt <= yellow_cnt;
                        state <= S_YELLOW;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S_YELLOW: begin
                    if (cnt == 0) begin
                        cnt <= red_cnt;
                        state <= S_RED;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            S_RED: begin
                red = 1'b1;
                yellow = 1'b0;
                green = 1'b0;
            end
            S_GREEN: begin
                red = 1'b0;
                yellow = 1'b0;
                green = 1'b1;
            end
            S_YELLOW: begin
                red = 1'b0;
                yellow = 1'b1;
                green = 1'b0;
            end
        endcase
    end

    assign clock = cnt;

endmodule