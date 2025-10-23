module traffic_light(
    input rst_n, 
    input clk, 
    input pass_request, 
    output reg [7:0] clock, 
    output reg red, 
    output reg yellow, 
    output reg green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

reg [1:0] state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: begin
                if (cnt == 0) state <= s3_green;
                else state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 0) state <= s1_red;
                else state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 0) state <= s2_yellow;
                else state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && green) cnt <= 10;
        else if (!green && p_green) cnt <= 60;
        else if (!yellow && p_yellow) cnt <= 5;
        else if (!red && p_red) cnt <= 10;
        else cnt <= cnt - 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s1_red: begin
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s2_yellow: begin
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end
            s3_green: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end
            default: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule