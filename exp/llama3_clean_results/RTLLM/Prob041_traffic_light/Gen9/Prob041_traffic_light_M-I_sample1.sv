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
    parameter RED_TIME = 10;
    parameter YELLOW_TIME = 5;
    parameter GREEN_TIME = 60;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    // State transition logic
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

    // Counter counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else if (pass_request && state == s3_green) begin
            cnt <= 10;
        end else if (cnt == 0) begin
            case (state)
                s1_red: cnt <= RED_TIME;
                s2_yellow: cnt <= YELLOW_TIME;
                s3_green: cnt <= GREEN_TIME;
                default: cnt <= 10;
            endcase
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
    end

    // Output signal assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
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

    assign clock = cnt;

endmodule