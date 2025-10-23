`timescale 1ns / 1ps
module traffic_light(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam [1:0]
        s1_red    = 2'b00,
        s2_yellow = 2'b01,
        s3_green  = 2'b10;

    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            s1_red: begin
                if (cnt == 0)
                    next_state = s3_green;
                else
                    next_state = s1_red;
            end
            s3_green: begin
                if (cnt == 0)
                    next_state = s2_yellow;
                else
                    next_state = s3_green;
            end
            s2_yellow: begin
                if (cnt == 0)
                    next_state = s1_red;
                else
                    next_state = s2_yellow;
            end
            default: next_state = s1_red;
        endcase
    end

    // State and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= s1_red;
            // Load red duration
            cnt <= 8'd10;
            // Initialize outputs
            red    <= 1'b1;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd10;
        end else begin
            state <= next_state;

            // Update outputs depending on next_state (Moore machine)
            case(next_state)
                s1_red: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                s3_green: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                s2_yellow: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase

            // Counter management
            if (cnt == 0) begin
                // On state transition, load new count depending on next_state
                case(next_state)
                    s1_red:    cnt <= 8'd10;  // red duration
                    s3_green:  cnt <= 8'd60;  // green duration
                    s2_yellow: cnt <= 8'd5;   // yellow duration
                    default:   cnt <= 8'd10;  // safe default
                endcase
            end else begin
                // Decrement counter each cycle
                // Pedestrian pass_request logic only applies in green state
                if ((state == s3_green) && pass_request) begin
                    // If remaining green time > 10, shorten it to 10
                    if (cnt > 8'd10)
                        cnt <= 8'd10;
                    else
                        cnt <= cnt - 1'b1;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end

            clock <= cnt;  // output current count value
        end
    end

endmodule