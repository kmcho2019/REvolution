module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states of the traffic light controller
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the internal counter
logic [7:0] cnt;

// Define the previous values of the output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt ==) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Counting logic of the internal counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && p_green && cnt > 10) begin
        cnt <= 10;
    end else if (!p_green && p_green =='b) begin
        cnt <= 60;
    end else if (!p_yellow && p_yellow == 1'b1) begin
        cnt <= 5;
    end else if (!p_red && p_red == 1'b1) begin
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red) ? 1'b1 : 0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 0;
        p_green <= (state == s3_green) ? 1'b1 : 0;
    end
end

assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule