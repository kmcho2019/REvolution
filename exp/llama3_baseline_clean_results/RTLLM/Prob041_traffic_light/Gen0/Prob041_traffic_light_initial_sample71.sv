module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
    logic [1:0] state, next_state;
    logic [7:0] cnt;
    logic p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: state <= s1_red;
                s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
                s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
                s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            case (state)
                s1_red: if (cnt == 0) cnt <= 10; else cnt <= cnt - 1;
                s2_yellow: if (cnt == 0) cnt <= 5; else cnt <= cnt - 1;
                s3_green: if (cnt == 0) cnt <= 60; else if (pass_request && cnt > 10) cnt <= 10; else cnt <= cnt - 1;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            case (state)
                s1_red: begin
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
                s2_yellow: begin
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end
                s3_green: begin
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    assign clock = cnt;

endmodule