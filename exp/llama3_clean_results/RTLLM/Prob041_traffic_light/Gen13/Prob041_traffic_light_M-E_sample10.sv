module traffic_light(
    input rst_n, clk, pass_request,
    output [7:0] clock,
    output reg red, output reg yellow, output reg green
);

    // Define the states
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Define the one-hot encoded states
    reg [3:0] state, next_state;
    reg [7:0] cnt;

    // Counter module
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            case (state)
                4'b0001: // s1_red
                    if (cnt == 0) begin
                        cnt <= 60;
                    end else begin
                        cnt <= cnt - 1;
                    end
                4'b0010: // s2_yellow
                    if (cnt == 0) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                4'b0100: // s3_green
                    if (cnt == 0) begin
                        cnt <= 5;
                    end else if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                default: cnt <= 10;
            endcase
        end
    end

    // State transition module
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001; // Initialize to s1_red
        end else begin
            case (state)
                4'b0001: // s1_red
                    if (cnt == 0) begin
                        state <= 4'b0100; // Transition to s3_green
                    end else begin
                        state <= 4'b0001; // Remain in s1_red
                    end
                4'b0010: // s2_yellow
                    if (cnt == 0) begin
                        state <= 4'b0001; // Transition to s1_red
                    end else begin
                        state <= 4'b0010; // Remain in s2_yellow
                    end
                4'b0100: // s3_green
                    if (cnt == 0) begin
                        state <= 4'b0010; // Transition to s2_yellow
                    end else begin
                        state <= 4'b0100; // Remain in s3_green
                    end
                default: state <= 4'b0001; // Default to s1_red
            endcase
        end
    end

    // Output signal generator module
    always @(*) begin
        case (state)
            4'b0001: // s1_red
                red = 1;
                yellow = 0;
                green = 0;
            4'b0010: // s2_yellow
                red = 0;
                yellow = 1;
                green = 0;
            4'b0100: // s3_green
                red = 0;
                yellow = 0;
                green = 1;
            default:
                red = 0;
                yellow = 0;
                green = 0;
        endcase
    end

    assign clock = cnt;

endmodule