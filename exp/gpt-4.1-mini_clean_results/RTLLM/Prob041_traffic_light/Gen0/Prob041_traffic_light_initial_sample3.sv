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
        idle      = 2'b00,
        s1_red    = 2'b01,
        s2_yellow = 2'b10,
        s3_green  = 2'b11;

    reg [7:0] cnt;
    reg [1:0] state;

    reg p_red, p_yellow, p_green;

    // State transition logic and output logic combinational (next-state outputs)
    always @(*) begin
        // Default outputs
        p_red    = 1'b0;
        p_yellow = 1'b0;
        p_green  = 1'b0;

        case(state)
            idle: begin
                // All signals off, transition immediately to s1_red
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
            s1_red: begin
                p_red = 1'b1;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
            s2_yellow: begin
                p_red = 1'b0;
                p_yellow = 1'b1;
                p_green = 1'b0;
            end
            s3_green: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b1;
            end
            default: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
        endcase
    end

    // State and counter update on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10;  // Start with red duration
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            // Update outputs from next values
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;

            // Count down logic and state transitions
            if (cnt == 0) begin
                // Transition to next state and reload counter accordingly
                case(state)
                    idle: begin
                        state <= s1_red;
                        cnt <= 8'd10;
                    end
                    s1_red: begin
                        state <= s3_green;
                        cnt <= 8'd60;
                    end
                    s3_green: begin
                        state <= s2_yellow;
                        cnt <= 8'd5;
                    end
                    s2_yellow: begin
                        state <= s1_red;
                        cnt <= 8'd10;
                    end
                    default: begin
                        state <= idle;
                        cnt <= 8'd10;
                    end
                endcase
            end else begin
                // In s3_green (green state), check pass_request
                if (state == s3_green && pass_request) begin
                    // If remaining green time > 10, shorten to 10
                    if (cnt > 8'd10)
                        cnt <= 8'd10;
                    else
                        cnt <= cnt - 1'b1;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
        end
    end

    // Assign current count value to output clock
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule