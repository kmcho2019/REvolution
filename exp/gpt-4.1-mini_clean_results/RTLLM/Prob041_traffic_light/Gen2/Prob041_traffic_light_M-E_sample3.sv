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

    // State encoding using a localparam enum style
    localparam [1:0]
        idle      = 2'b00,
        s1_red    = 2'b01,
        s2_yellow = 2'b10,
        s3_green  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] cnt;           // countdown counter
    reg prev_red, prev_yellow, prev_green; // track previous outputs for counter reload

    // Next state logic combinational
    always @(*) begin
        case(state)
            idle: 
                next_state = s1_red; // immediate transition
            s1_red:
                if (cnt == 8'd0) 
                    next_state = s3_green;
                else 
                    next_state = s1_red;
            s2_yellow:
                if (cnt == 8'd0) 
                    next_state = s1_red;
                else 
                    next_state = s2_yellow;
            s3_green:
                if (cnt == 8'd0) 
                    next_state = s2_yellow;
                else 
                    next_state = s3_green;
            default:
                next_state = idle;
        endcase
    end

    // Sequential logic: state transition, counter management, output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all
            state       <= idle;
            cnt         <= 8'd0;
            red         <= 1'b0;
            yellow      <= 1'b0;
            green       <= 1'b0;
            prev_red    <= 1'b0;
            prev_yellow <= 1'b0;
            prev_green  <= 1'b0;
            clock       <= 8'd0;
        end else begin
            state <= next_state;

            // Determine outputs based on next_state (Moore machine)
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

            // Save previous outputs to detect output changes
            prev_red    <= red;
            prev_yellow <= yellow;
            prev_green  <= green;

            // Counter reload on output changes (state change)
            if ( (red != prev_red) || (yellow != prev_yellow) || (green != prev_green) ) begin
                case(next_state)
                    idle:      cnt <= 8'd0;
                    s1_red:    cnt <= 8'd10;
                    s2_yellow: cnt <= 8'd5;
                    s3_green:  cnt <= 8'd60;
                    default:   cnt <= 8'd0;
                endcase
            end else begin
                // Pedestrian request logic only valid in green state
                if (state == s3_green && pass_request) begin
                    // If remaining green time > 10, shorten to 10
                    if (cnt > 8'd10)
                        cnt <= 8'd10;
                    else if (cnt > 0)
                        cnt <= cnt - 1'b1;
                    else
                        cnt <= 0;
                end else begin
                    if (cnt > 0)
                        cnt <= cnt - 1'b1;
                    else
                        cnt <= 0;
                end
            end

            // Update output clock with current counter value
            clock <= cnt;
        end
    end

endmodule