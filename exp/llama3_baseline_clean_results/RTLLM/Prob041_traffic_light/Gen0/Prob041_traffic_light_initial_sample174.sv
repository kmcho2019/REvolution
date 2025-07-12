module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
        endcase
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cnt <= 10;
    else if (pass_request && p_green) cnt <= 10;
    else if (!p_green && p_green) cnt <= 60;
    else if (!p_yellow && p_yellow) cnt <= 5;
    else if (!p_red && p_red) cnt <= 10;
    else if (cnt > 0) cnt <= cnt - 1;
end

// Output signals
assign clock = cnt;
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule