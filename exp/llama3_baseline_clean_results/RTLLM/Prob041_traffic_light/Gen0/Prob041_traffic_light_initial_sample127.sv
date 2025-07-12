module traffic_light(
    input logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

    // Define the enumeration values for different states
    enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

    // Define the internal counter and output signals
    logic [7:0] cnt;
    logic p_red, p_yellow, p_green;

    // Always block for state transition logic
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
                    end else if (pass_request && cnt > 10) begin
                        next_state <= s3_green;
                        cnt <= 10;
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

    // Always block for counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            case (state)
                s1_red: begin
                    if (cnt == 0) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        cnt <= 5;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    if (cnt == 0) begin
                        cnt <= 60;
                    end else if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    cnt <= cnt;
                end
            endcase
        end
    end

    // Always block for output signal assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
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
                default: begin
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 0;
                end
            endcase
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    // Assign the value of the internal counter to the output clock
    assign clock = cnt;

endmodule