module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
            if (pass_request && green) begin
                if (cnt > 10) cnt <= 10;
            end else if (green && cnt == 0) begin
                cnt <= 5; // Transition to yellow
            end else if (yellow && cnt == 0) begin
                cnt <= 10; // Transition to red
            end else if (red && cnt == 0) begin
                cnt <= 60; // Transition to green
            end else begin
                cnt <= cnt - 1;
            end
            case (state)
                idle: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
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

    always @(*) begin
        case (state)
            idle: next_state = s1_red;
            s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
            s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
            s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
            default: next_state = idle;
        endcase
    end

    assign clock = cnt;

endmodule