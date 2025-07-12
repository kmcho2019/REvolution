module traffic_light(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input pass_request,  // Request signal for allowing vehicles to pass
    output [7:0] clock,  // An 8-bit output representing the count value of the internal counter
    output red, yellow, green  // Output signals representing the state of the traffic lights
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green, next_p_red, next_p_yellow, next_p_green;

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end
    else
    begin
        state <= next_state;
        p_red <= next_p_red;
        p_yellow <= next_p_yellow;
        p_green <= next_p_green;
    end
end

always @(*)
begin
    case (state)
        idle:
        begin
            next_state = s1_red;
            next_p_red = 1'b1;
            next_p_yellow = 1'b0;
            next_p_green = 1'b0;
        end
        s1_red:
        begin
            next_state = (cnt == 10) ? s3_green : s1_red;
            next_p_red = 1'b1;
            next_p_yellow = 1'b0;
            next_p_green = 1'b0;
        end
        s2_yellow:
        begin
            next_state = (cnt == 5) ? s1_red : s2_yellow;
            next_p_red = 1'b0;
            next_p_yellow = 1'b1;
            next_p_green = 1'b0;
        end
        s3_green:
        begin
            next_state = (cnt == 60) ? s2_yellow : s3_green;
            next_p_red = 1'b0;
            next_p_yellow = 1'b0;
            next_p_green = 1'b1;
        end
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        cnt <= 10;
    else
    begin
        if (pass_request && p_green)
            cnt <= 10;
        else if (~p_green && p_green)
            cnt <= 60;
        else if (~p_yellow && p_yellow)
            cnt <= 5;
        else if (~p_red && p_red)
            cnt <= 10;
        else
            cnt <= cnt - 1;
    end
end

assign clock = cnt;

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end
    else
    begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule