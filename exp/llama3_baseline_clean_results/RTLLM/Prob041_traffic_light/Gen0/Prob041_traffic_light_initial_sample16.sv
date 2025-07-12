module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    reg [1:0] state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: state <= s1_red;
                s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
                s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
                s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
                default: state <= idle;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            if (pass_request && p_green && cnt > 10) cnt <= 10;
            else if (!p_green && p_green == 1) cnt <= 60;
            else if (!p_yellow && p_yellow == 1) cnt <= 5;
            else if (!p_red && p_red == 1) cnt <= 10;
            else if (cnt > 0) cnt <= cnt - 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    assign clock = cnt;

endmodule