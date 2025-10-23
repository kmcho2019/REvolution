module traffic_light(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input pass_request,  // Request signal for allowing vehicles to pass
    output [7:0] clock,  // An 8-bit output representing the count value of the internal counter
    output reg red, yellow, green  // Output signals representing the state of the traffic lights
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        state <= idle;
        cnt <= 10;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end
    else
    begin
        case (state)
            idle:
            begin
                state <= s1_red;
                cnt <= 10;
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s1_red:
            begin
                if (cnt == 0)
                begin
                    state <= s3_green;
                    cnt <= 60;
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            s3_green:
            begin
                if (pass_request && cnt > 10)
                    cnt <= 10;
                if (cnt == 0)
                begin
                    state <= s2_yellow;
                    cnt <= 5;
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow:
            begin
                if (cnt == 0)
                begin
                    state <= s1_red;
                    cnt <= 10;
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                else
                begin
                    cnt <= cnt - 1;
                end
            end
            default: state <= idle;
        endcase
    end
end

assign clock = cnt;

endmodule