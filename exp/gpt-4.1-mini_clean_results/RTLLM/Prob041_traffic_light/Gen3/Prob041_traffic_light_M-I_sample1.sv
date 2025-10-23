`timescale 1ns / 1ps
module traffic_light (
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
        idle      = 2'b00,
        s1_red    = 2'b01,
        s2_yellow = 2'b10,
        s3_green  = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] prev_state;
    reg [7:0] cnt;

    // Next state combinational logic
    always @(*) begin
        case(state)
            idle:
                next_state = s1_red;
            s1_red:
                next_state = (cnt == 8'd0) ? s3_green : s1_red;
            s2_yellow:
                next_state = (cnt == 8'd0) ? s1_red : s2_yellow;
            s3_green:
                next_state = (cnt == 8'd0) ? s2_yellow : s3_green;
            default:
                next_state = idle;
        endcase
    end

    // Sequential logic: state transition, counter, output signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= idle;
            prev_state <= idle;
            cnt     <= 8'd0;
            red     <= 1'b0;
            yellow  <= 1'b0;
            green   <= 1'b0;
            clock   <= 8'd0;
        end else begin
            state <= next_state;

            // Detect state change by comparing with previous state
            if (next_state != prev_state) begin
                // Reload counter according to new state
                case(next_state)
                    idle:      cnt <= 8'd0;
                    s1_red:    cnt <= 8'd10;  // red duration
                    s2_yellow: cnt <= 8'd5;   // yellow duration
                    s3_green:  cnt <= 8'd60;  // green duration
                    default:   cnt <= 8'd0;
                endcase
            end else begin
                // If still in same state, handle counting down
                if (next_state == s3_green) begin
                    // Pedestrian request: shorten green to 10 if >10
                    if (pass_request && (cnt > 8'd10)) begin
                        cnt <= 8'd10;
                    end else if (cnt > 0) begin
                        cnt <= cnt - 1'b1;
                    end else begin
                        cnt <= 8'd0;
                    end
                end else begin
                    // For other states, just count down if > 0
                    if (cnt > 0)
                        cnt <= cnt - 1'b1;
                    else
                        cnt <= 8'd0;
                end
            end

            // Update prev_state for next cycle
            prev_state <= next_state;

            // Output signals set synchronously (Moore FSM)
            case(next_state)
                idle: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                s1_red: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                s2_yellow: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                s3_green: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase

            // Assign current counter value to output clock
            clock <= cnt;
        end
    end

endmodule