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
    reg [7:0] next_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
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
                default: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        next_cnt = cnt;
        case (state)
            idle: next_state = s1_red;
            s1_red: if (cnt == 0) next_state = s3_green; 
            s2_yellow: if (cnt == 0) next_state = s1_red; 
            s3_green: if (cnt == 0) next_state = s2_yellow; 
            default: next_state = idle;
        endcase
        if (pass_request && green && cnt > 10) begin
            next_cnt = 10;
        end else if (cnt == 0) begin
            case (state)
                s1_red: next_cnt = 60;
                s2_yellow: next_cnt = 5;
                s3_green: next_cnt = 10;
                default: next_cnt = 10;
            endcase
        end else if (cnt > 0) begin
            next_cnt = cnt - 1;
        end
    end

    assign clock = cnt;

endmodule