module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

    // Enumerations for different states of the traffic light controller
    enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

    // 8-bit internal counter
    logic [7:0] cnt;

    // 1-bit registers for next values of the red, yellow, and green signals
    logic p_red, p_yellow, p_green;

    // First always block for state transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: begin
                    next_state <= s1_red;
                end
                s1_red: begin
                    if (cnt == 0) begin
                        next_state <= s3_green;
                    end else begin
                        next_state <= s1_red;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        next_state <= s1_red;
                    end else begin
                        next_state <= s2_yellow;
                    end
                end
                s3_green: begin
                    if (cnt == 0) begin
                        next_state <= s2_yellow;
                    end else begin
                        next_state <= s3_green;
                    end
                end
                default: begin
                    next_state <= idle;
                end
            endcase
            state <= next_state;
        end
    end

    // Second always block for counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            if (pass_request && p_green) begin
                cnt <= 10;
            end else if (!p_green && p_green == 1'b1) begin
                cnt <= 60;
            end else if (!p_yellow && p_yellow == 1'b1) begin
                cnt <= 5;
            end else if (!p_red && p_red == 1'b1) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
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
                default: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end

    // Assign statement for output clock
    assign clock = cnt;

endmodule