module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    // Counter module
    module counter(
        input [1:0] state,
        input clk, rst_n,
        output [7:0] cnt
    );
        reg [7:0] cnt_reg;
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                cnt_reg <= 0;
            end else begin
                case (state)
                    s1_red: cnt_reg <= (cnt_reg == 0) ? 10 : cnt_reg - 1;
                    s2_yellow: cnt_reg <= (cnt_reg == 0) ? 5 : cnt_reg - 1;
                    s3_green: cnt_reg <= (cnt_reg == 0) ? 60 : cnt_reg - 1;
                    default: cnt_reg <= 0;
                endcase
            end
        end
        assign cnt = cnt_reg;
    endmodule

    // Pedestrian button press detector
    module ped_button_press(
        input pass_request,
        output reg button_press
    );
        reg prev_pass_request;
        always @(posedge clk) begin
            if (pass_request && !prev_pass_request) begin
                button_press <= 1;
            end else begin
                button_press <= 0;
            end
            prev_pass_request <= pass_request;
        end
    endmodule

    // FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
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
            s3_green: if (cnt == 0) next_state = s2_yellow; else if (pass_request) next_state = s2_yellow; else next_state = s3_green;
            default: next_state = idle;
        endcase
    end

    counter u_counter(
        .state(state),
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt)
    );

    ped_button_press u_ped_button_press(
        .pass_request(pass_request),
        .button_press(button_press)
    );

    assign clock = cnt;

endmodule