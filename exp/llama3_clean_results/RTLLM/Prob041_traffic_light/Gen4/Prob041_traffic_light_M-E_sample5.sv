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

// Mealy machine (counting logic)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    cnt <= 60;
                end else if (pass_request && cnt > 10) begin
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
        endcase
    end
end

// Moore machine (state transition logic)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        red_reg <= 0;
        yellow_reg <= 0;
        green_reg <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                red_reg <= 1;
                yellow_reg <= 0;
                green_reg <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    red_reg <= 0;
                    yellow_reg <= 0;
                    green_reg <= 1;
                end else begin
                    state <= s1_red;
                    red_reg <= 1;
                    yellow_reg <= 0;
                    green_reg <= 0;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    red_reg <= 0;
                    yellow_reg <= 1;
                    green_reg <= 0;
                end else begin
                    state <= s3_green;
                    red_reg <= 0;
                    yellow_reg <= 0;
                    green_reg <= 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    red_reg <= 1;
                    yellow_reg <= 0;
                    green_reg <= 0;
                end else begin
                    state <= s2_yellow;
                    red_reg <= 0;
                    yellow_reg <= 1;
                    green_reg <= 0;
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