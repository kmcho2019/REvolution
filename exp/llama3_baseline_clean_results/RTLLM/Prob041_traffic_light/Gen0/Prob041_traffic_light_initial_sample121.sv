module traffic_light(
    input         rst_n,
    input         clk,
    input         pass_request,
    output [7:0]  clock,
    output        red,
    output        yellow,
    output        green
);

// Define enumeration values for different states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define registers and wires
reg [7:0] cnt;
reg [1:0] state;
reg       p_red, p_yellow, p_green;
reg       red_reg, yellow_reg, green_reg;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                end else begin
                    state <= s1_red;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                end else begin
                    state <= s2_yellow;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                end else if (pass_request && p_green) begin
                    if (cnt > 10) begin
                        cnt <= 10;
                    end
                end else begin
                    state <= s3_green;
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

// Counting logic
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
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    cnt <= 60;
                end else if (pass_request && p_green) begin
                    if (cnt > 10) begin
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                cnt <= 10;
            end
        endcase
    end
end

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red_reg <= 0;
        yellow_reg <= 0;
        green_reg <= 0;
    end else begin
        case (state)
            s1_red: begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s2_yellow: begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end
            s3_green: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
            end
            default: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
        endcase
        red_reg <= p_red;
        yellow_reg <= p_yellow;
        green_reg <= p_green;
    end
end

// Assign output signals
assign clock = cnt;
assign red = red_reg;
assign yellow = yellow_reg;
assign green = green_reg;

endmodule