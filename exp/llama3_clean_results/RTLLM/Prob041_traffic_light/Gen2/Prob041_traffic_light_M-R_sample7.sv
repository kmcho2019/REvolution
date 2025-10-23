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
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// Always block: State transition logic and counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
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
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    cnt <= 5;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
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
        p_red <= (state == s1_red) ? 1'b1 : 1'b0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 1'b0;
        p_green <= (state == s3_green) ? 1'b1 : 1'b0;
    end
end

// Assign the output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;
assign clock = cnt;

endmodule