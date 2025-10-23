module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output wire red,
    output wire yellow,
    output wire green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Internal registers
reg [1:0] state;
reg [7:0] cnt;
reg p_green;

// State transition and counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 10;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    cnt <= 60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                p_green <= 1;
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end
                if (cnt == 0) begin
                    state <= s2_yellow;
                    cnt <= 5;
                    p_green <= 0;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Output signals
assign clock = cnt;
assign red = (state == s1_red);
assign yellow = (state == s2_yellow);
assign green = (state == s3_green && p_green);

endmodule