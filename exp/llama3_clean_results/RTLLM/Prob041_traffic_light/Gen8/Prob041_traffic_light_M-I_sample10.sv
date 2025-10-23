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

    // Simplified state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
            case (state)
                s1_red: begin
                    if (cnt > 0) cnt <= cnt - 1;
                    else begin
                        cnt <= 60; // Transition to green
                        if (pass_request) cnt <= 10; // Adjust count based on pass_request
                    end
                end
                s2_yellow: begin
                    if (cnt > 0) cnt <= cnt - 1;
                    else cnt <= 5; // Transition to yellow
                end
                s3_green: begin
                    if (cnt > 0) cnt <= cnt - 1;
                    else cnt <= 10; // Transition to red
                end
                default: begin
                    cnt <= 10;
                end
            endcase
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

    // Next state logic
    always @(*) begin
        case (state)
            idle: next_state = s1_red;
            s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
            s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
            s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
            default: next_state = idle;
        endcase
    end

    // Assign clock output
    assign clock = cnt;

endmodule