module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
            cnt <= 10;
        end else begin
            state <= next_state;
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
            if (pass_request && p_green) begin
                cnt <= 10;
            end else if (!p_green && p_green == 1) begin
                cnt <= 60;
            end else if (!p_yellow && p_yellow == 1) begin
                cnt <= 5;
            end else if (!p_red && p_red == 1) begin
                cnt <= 10;
            end else if (cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
    end

    always @(*) begin
        case (state)
            idle: begin
                red = 0;
                yellow = 0;
                green = 0;
                next_state = s1_red;
            end
            s1_red: begin
                red = 1;
                yellow = 0;
                green = 0;
                if (cnt == 0) next_state = s3_green; else next_state = s1_red;
            end
            s2_yellow: begin
                red = 0;
                yellow = 1;
                green = 0;
                if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
            end
            s3_green: begin
                red = 0;
                yellow = 0;
                green = 1;
                if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
            end
            default: begin
                red = 0;
                yellow = 0;
                green = 0;
                next_state = idle;
            end
        endcase
    end

    assign clock = cnt;

endmodule