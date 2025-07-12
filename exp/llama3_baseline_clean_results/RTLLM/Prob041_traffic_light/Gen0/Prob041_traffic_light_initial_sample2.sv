module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

    // Define the states
    enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

    // Define the registers
    logic [7:0] cnt;
    logic p_red, p_yellow, p_green;

    // First always block: state transition logic
    always_ff @(posedge clk or negedge rst_n) begin
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

    // Second always block: counting logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            case (state)
                idle: begin
                    cnt <= 10;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 0;
                end
                s1_red: begin
                    if (cnt == 0) begin
                        p_red <= 1;
                        p_yellow <= 0;
                        p_green <= 0;
                    end else if (pass_request && p_green) begin
                        cnt <= 10;
                    end else if (!p_green && p_green) begin
                        cnt <= 60;
                    end else if (!p_yellow && p_yellow) begin
                        cnt <= 5;
                    end else if (!p_red && p_red) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        p_red <= 0;
                        p_yellow <= 1;
                        p_green <= 0;
                    end else if (pass_request && p_green) begin
                        cnt <= 10;
                    end else if (!p_green && p_green) begin
                        cnt <= 60;
                    end else if (!p_yellow && p_yellow) begin
                        cnt <= 5;
                    end else if (!p_red && p_red) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    if (cnt == 0) begin
                        p_red <= 0;
                        p_yellow <= 0;
                        p_green <= 1;
                    end else if (pass_request && p_green) begin
                        cnt <= 10;
                    end else if (!p_green && p_green) begin
                        cnt <= 60;
                    end else if (!p_yellow && p_yellow) begin
                        cnt <= 5;
                    end else if (!p_red && p_red) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    cnt <= 10;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 0;
                end
            endcase
        end
    end

    // Assign statement: assign the value of the internal counter to the output clock
    assign clock = cnt;

    // Final always block: handle the output signals
    always_ff @(posedge clk or negedge rst_n) begin
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

endmodule