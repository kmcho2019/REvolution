module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

    // Define parameters for different states
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Define registers for internal counter and state
    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // First always block for state transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            p_red <= 1'b0;
            p_yellow <= 1'b0;
            p_green <= 1'b0;
        end else begin
            case (state)
                idle: state <= s1_red;
                s1_red: if (cnt == 0) state <= s3_green;
                s2_yellow: if (cnt == 0) state <= s1_red;
                s3_green: if (cnt == 0) state <= s2_yellow;
                default: state <= idle;
            endcase
            if (pass_request && p_green && cnt > 10) begin
                cnt <= 10;
            end
        end
    end

    // Second always block for counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            case (state)
                s1_red: if (cnt == 0) cnt <= 10;
                s2_yellow: if (cnt == 0) cnt <= 5;
                s3_green: if (cnt == 0) cnt <= 60;
                default: cnt <= cnt - 1;
            endcase
            if (pass_request && p_green && cnt > 10) begin
                cnt <= 10;
            end
        end
    end

    // Assign output signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
            case (state)
                idle: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                s1_red: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                s2_yellow: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                s3_green: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
        end
    end

    // Assign internal counter to output clock
    assign clock = cnt;

endmodule