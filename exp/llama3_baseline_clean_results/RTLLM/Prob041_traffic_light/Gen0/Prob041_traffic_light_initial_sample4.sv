module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] cnt;
reg p_red;
reg p_yellow;
reg p_green;
reg red_out;
reg yellow_out;
reg green_out;

always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        if (pass_request && p_green) begin
            if (cnt > 10) cnt <= 10; else cnt <= cnt;
        end else if (!p_green && p_green == 1) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow == 1) begin
            cnt <= 5;
        end else if (!p_red && p_red == 1) begin
            cnt <= 10;
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
        p_red <= red_out;
        p_yellow <= yellow_out;
        p_green <= green_out;
    end
end

always @(*) begin
    case (state)
        idle: begin
            red_out = 0;
            yellow_out = 0;
            green_out = 0;
        end
        s1_red: begin
            red_out = 1;
            yellow_out = 0;
            green_out = 0;
        end
        s2_yellow: begin
            red_out = 0;
            yellow_out = 1;
            green_out = 0;
        end
        s3_green: begin
            red_out = 0;
            yellow_out = 0;
            green_out = 1;
        end
        default: begin
            red_out = 0;
            yellow_out = 0;
            green_out = 0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= red_out;
        yellow <= yellow_out;
        green <= green_out;
    end
end

assign clock = cnt;

endmodule