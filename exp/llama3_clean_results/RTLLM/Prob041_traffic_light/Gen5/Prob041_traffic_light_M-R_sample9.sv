module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the states of the traffic light controller
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the registers and wires
reg [7:0] cnt;
reg [7:0] next_cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 0)? s3_green : s1_red;
        s3_green: next_state = (cnt == 0)? s2_yellow : s3_green;
        s2_yellow: next_state = (cnt == 0)? s1_red : s2_yellow;
    endcase
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red) begin
            if (cnt == 0) begin
                cnt <= 60;
            end else if (pass_request && cnt > 10) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end else if (state == s3_green) begin
            if (cnt == 0) begin
                cnt <= 5;
            end else if (pass_request && cnt > 10) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end else if (state == s2_yellow) begin
            if (cnt == 0) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end
end

// Assign the output signals
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green);
assign clock = cnt;

endmodule