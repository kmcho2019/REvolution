`timescale 1ns / 1ps

module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the parameters for the states
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Declare the registers and wires
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;
reg [1:0] next_state;

// Assign the value of the internal counter to the output clock
assign clock = cnt;

// First always block: state transition logic
always @(*) begin
    case(state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Second always block: counting logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case(state)
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else if (cnt == 0) begin
                    cnt <= 60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: cnt <= cnt - 1;
        endcase
    end
end

// Third always block: output signals
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        p_red <= (state == s1_red) ? 1 : 0;
        p_yellow <= (state == s2_yellow) ? 1 : 0;
        p_green <= (state == s3_green) ? 1 : 0;
    end
end

// Assign the previous values to the output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule