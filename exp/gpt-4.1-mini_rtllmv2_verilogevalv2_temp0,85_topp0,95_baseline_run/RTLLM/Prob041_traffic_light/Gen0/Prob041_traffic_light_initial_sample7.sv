module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State encoding
    parameter idle = 2'b00,
              s1_red = 2'b01,
              s2_yellow = 2'b10,
              s3_green = 2'b11;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition and output logic
    always @(*) begin
        // Default next light outputs are zero
        p_red = 0;
        p_yellow = 0;
        p_green = 0;
        case (state)
            idle: begin
                // All off
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end
            s1_red: begin
                p_red = 1;
            end
            s2_yellow: begin
                p_yellow = 1;
            end
            s3_green: begin
                p_green = 1;
            end
            default: begin
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end
        endcase
    end

    // State transition and counter management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;  // Start red with 10 clocks as per specs
        end else begin
            case (state)
                idle: begin
                    // Transition immediately to s1_red
                    state <= s1_red;
                    cnt <= 10; // red light for 10 clocks
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= 60; // green light default 60 clocks
                    end else begin
                        state <= s1_red;
                    end
                end
                s3_green: begin
                    // Handle pedestrian button shortening
                    if (pass_request && (cnt > 10))
                        cnt <= 10;
                    else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 5;  // yellow light 5 clocks
                    end else begin
                        state <= s3_green;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= 10; // red light 10 clocks
                    end else begin
                        state <= s2_yellow;
                    end
                end
                default: begin
                    state <= idle;
                    cnt <= 10;
                end
            endcase

            // Decrement cnt if it's not zero and no immediate reset by pass_request
            if (cnt != 0) begin
                // We decrement cnt only if not shortened by pass_request in s3_green
                if (!(state == s3_green && pass_request && (cnt > 10)))
                    cnt <= cnt - 1;
            end
        end
    end

    // Update outputs with next signals on clock or reset
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

    // Output the current counter value
    assign clock = cnt;

endmodule