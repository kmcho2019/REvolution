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
    reg [1:0] state;

    // Next-state combinational logic
    reg [1:0] next_state;

    // On reset or clock edge, update state and outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= s1_red;
            cnt    <= 8'd10;
            red    <= 1'b1;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd10;
        end else begin
            // Pedestrian request logic during green state to shorten green time if > 10
            if (state == s3_green && pass_request && (cnt > 8'd10)) begin
                cnt <= 8'd10;
            end else if (cnt == 0) begin
                // State transition and counter reload
                case (state)
                    s1_red: begin
                        state  <= s3_green;
                        cnt    <= 8'd60;
                        red    <= 1'b0;
                        yellow <= 1'b0;
                        green  <= 1'b1;
                    end
                    s3_green: begin
                        state  <= s2_yellow;
                        cnt    <= 8'd5;
                        red    <= 1'b0;
                        yellow <= 1'b1;
                        green  <= 1'b0;
                    end
                    s2_yellow: begin
                        state  <= s1_red;
                        cnt    <= 8'd10;
                        red    <= 1'b1;
                        yellow <= 1'b0;
                        green  <= 1'b0;
                    end
                    default: begin
                        state  <= s1_red;
                        cnt    <= 8'd10;
                        red    <= 1'b1;
                        yellow <= 1'b0;
                        green  <= 1'b0;
                    end
                endcase
            end else begin
                // Normal count down
                cnt <= cnt - 1'b1;
            end

            clock <= cnt;
        end
    end

endmodule