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
reg red_reg, yellow_reg, green_reg;

// State transition and counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        red_reg <= 0;
        yellow_reg <= 0;
        green_reg <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                cnt <= 10;
                red_reg <= 1;
                yellow_reg <= 0;
                green_reg <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    cnt <= 60;
                    red_reg <= 0;
                    yellow_reg <= 0;
                    green_reg <= 1;
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
                    red_reg <= 0;
                    yellow_reg <= 1;
                    green_reg <= 0;
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
                    red_reg <= 1;
                    yellow_reg <= 0;
                    green_reg <= 0;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Assign the output signals
assign red = red_reg;
assign yellow = yellow_reg;
assign green = green_reg;
assign clock = cnt;

endmodule