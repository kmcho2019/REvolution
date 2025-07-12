module traffic_light(
    input               rst_n,
    input               clk,
    input               pass_request,
    output [7:0]        clock,
    output              red,
    output              yellow,
    output              green
);

    // Define the states
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Internal registers
    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // Next state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: state <= s1_red;
                s1_red: begin
                    if (cnt == 0) state <= s3_green;
                    else state <= s1_red;
                end
                s2_yellow: begin
                    if (cnt == 0) state <= s1_red;
                    else state <= s2_yellow;
                end
                s3_green: begin
                    if (cnt == 0) state <= s2_yellow;
                    else state <= s3_green;
                end
            endcase
        end
    end

    // Counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            if (state == s1_red && p_red == 0) begin
                cnt <= 10;
            end else if (state == s3_green && p_green == 0) begin
                cnt <= 60;
            end else if (state == s2_yellow && p_yellow == 0) begin
                cnt <= 5;
            end else if (state == s3_green && pass_request && cnt > 10) begin
                cnt <= 10;
            end else if (cnt > 0) begin
                cnt <= cnt - 1;
            end
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
        end
    end

    // Output logic
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

    // Assign counter value to output
    assign clock = cnt;

endmodule